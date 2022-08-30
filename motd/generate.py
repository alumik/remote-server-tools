from colorama import Fore, Style

with open('motd', 'w') as f:
    f.write(Style.BRIGHT)
    f.write('╔══════════════════════════════════════════════════════════════════════╗\n')
    f.write('║大家好！为了提高服务器计算资源的流转效率，更好的为大家的科研工作服务。║\n')
    f.write('║现提供《服务器作业管理平台》进一步规范服务器的使用和管理。平台地址为：║\n')
    f.write('║┌───────────────────────┐                                             ║\n')
    f.write('║│  http://10.10.1.210/  │                                             ║\n')
    f.write('║└───────────────────────┘                                             ║\n')
    f.write('║该平台主要提供服务器状态查询和作业登记管理功能。请各位用户在服务器上执║\n')
    f.write('║行任务前先在该平台进行简单作业信息登记。                              ║\n')
    f.write('╟──────────────────────────────────────────────────────────────────────╢\n')
    f.write('║')
    f.write(Fore.YELLOW)
    f.write('请注意：未在该平台登记的服务器作业可能被清理（SIGTERM）。')
    f.write(Fore.RESET)
    f.write('             ║\n')
    f.write('╟──────────────────────────────────────────────────────────────────────╢\n')
    f.write('║')
    f.write(Fore.RED)
    f.write(f'请务必准确填写和及时更新 PID。')
    f.write(Fore.RESET)
    f.write('                                        ║\n')
    f.write('║')
    f.write(Fore.RED)
    f.write('该平台每隔30分钟会清理一次未登记或过期的 GPU 进程。')
    f.write(Fore.RESET)
    f.write('                   ║\n')
    f.write('╚══════════════════════════════════════════════════════════════════════╝\n')
    f.write(Style.RESET_ALL)