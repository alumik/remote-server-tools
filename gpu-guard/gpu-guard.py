import re
import sys
import json
import logging
import requests
import subprocess

from logging.handlers import RotatingFileHandler

pids = subprocess.run(['nvidia-smi', '--query-compute-apps=pid', '--format=csv,noheader'],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')
pids = [int(pid) for pid in pids.strip().split()]
pids = set(pids)

server = sys.argv[1]
job_pids = requests.get('http://10.10.1.210/api/v1/job/gpu?server=' + server, timeout=5)
job_pids.raise_for_status()
job_pids = set(json.loads(job_pids.content))

unregistered_pids = pids - job_pids

log_formatter = logging.Formatter('[%(asctime)s] %(message)s')
my_handler = RotatingFileHandler('/root/gpu-guard.log', mode='a', maxBytes=100 * 1024 * 1024, backupCount=2,
                                 encoding=None, delay=False)
my_handler.setFormatter(log_formatter)
my_handler.setLevel(logging.INFO)
app_log = logging.getLogger('root')
app_log.setLevel(logging.INFO)
app_log.addHandler(my_handler)

print('PID:', pids)
print('JOB PID:', job_pids)
print('UNREGISTERD PID:', unregistered_pids)

for pid in unregistered_pids:
    process_info = subprocess.run(['ps', '-o', 'pid,user:15,cmd', '-p', str(pid), '--no-headers'],
                                  stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
    app_log.info(process_info)
    _pid, user, command = [item.strip() for item in re.sub(r'\s+', ' ', process_info).split(maxsplit=2)]
    requests.post(
        'http://10.10.1.210/api/v1/server/killed',
        json={'server': server, 'pid': _pid, 'user': user, 'command': command},
        timeout=5)
    subprocess.run(['kill', '-9', str(pid)])
