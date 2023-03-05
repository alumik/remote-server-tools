import re
import sys
import json
import logging
import pathlib
import requests
import subprocess

from logging.handlers import RotatingFileHandler

with open(pathlib.Path(__file__).resolve().parent / 'config.json', 'r') as f:
    config = json.load(f)

pids = subprocess.run(
    ['nvidia-smi', '--query-compute-apps=pid', '--format=csv,noheader'],
    stdout=subprocess.PIPE,
).stdout.decode('utf-8')
pids = [int(pid) for pid in pids.strip().split()]
pids = set(pids)

server = sys.argv[1]
registered_pids = requests.get(config['urls']['pid_query'].replace('{server}', server), timeout=5)
registered_pids.raise_for_status()
registered_pids = set(json.loads(registered_pids.content))

unregistered_pids = pids - registered_pids

log_formatter = logging.Formatter('[%(asctime)s] %(message)s')
pathlib.Path(config['log']).parent.mkdir(parents=True, exist_ok=True)
my_handler = RotatingFileHandler(
    config['log'],
    mode='a',
    maxBytes=100 * 1024 * 1024,
    backupCount=2,
    encoding=None,
    delay=False,
)
my_handler.setFormatter(log_formatter)
my_handler.setLevel(logging.INFO)
app_log = logging.getLogger('root')
app_log.setLevel(logging.INFO)
app_log.addHandler(my_handler)

print(json.dumps({
    'pids': list(pids),
    'registered_pids': list(registered_pids),
    'unregistered_pids': list(unregistered_pids),
}, indent=2))

for pid in unregistered_pids:
    try:
        process_info = subprocess.run(
            ['ps', '-o', 'pid,user:15,cmd', '-p', str(pid), '--no-headers'],
            stdout=subprocess.PIPE,
        ).stdout.decode('utf-8').strip()
        app_log.info(process_info)
        _pid, user, command = [item.strip() for item in re.sub(r'\s+', ' ', process_info).split(maxsplit=2)]
        if user not in config['whitelist']['users']:
            requests.post(
                config['urls']['register_kill'],
                json={'server': server, 'pid': _pid, 'user': user, 'command': command},
                timeout=5,
            )
            subprocess.run(['kill', str(pid)])
    except Exception:
        pass
