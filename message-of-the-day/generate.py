import fire
import urwid
import colorama

from typing import *


def char_len(char: str) -> int:
    return urwid.util.str_util.get_width(ord(char))


def set_color(color: str = colorama.Fore.RESET) -> str:
    return '' if color is None else color


def fixed_len_splitter(text: str, max_len: int) -> str:
    cur_line = ''
    cur_len = 0
    for char in text:
        if cur_len + char_len(char) > max_len:
            yield cur_line
            cur_line = ''
            cur_len = 0
        cur_line += char
        cur_len += char_len(char)
    yield cur_line


class Line:

    def __init__(self, text: str, color: Optional[str] = None):
        self.text = text
        self.color = color

    def render(self) -> str:
        return f'{set_color(self.color)}{self.text}{set_color()}'

    def __len__(self) -> int:
        return sum([char_len(char) for char in self.text])


class Cell:

    def __init__(self, text: str, color: Optional[str] = None):
        self.text = text
        self.color = color
        self.lines = None

    def splitlines(self, max_len: int):
        self.lines = []
        text_lines = self.text.splitlines()
        for text_line in text_lines:
            for line in fixed_len_splitter(text_line, max_len):
                self.lines.append(Line(line, self.color))


class MotDGenerator:

    def __init__(self, max_len: int = 60):
        self._max_len = max_len
        self._cells = []

    def _top_rule(self) -> str:
        return '╔' + '═' * self._max_len + '╗'

    def _middle_rule(self) -> str:
        return '╟' + '─' * self._max_len + '╢'

    def _bottom_rule(self) -> str:
        return '╚' + '═' * self._max_len + '╝'

    def add_cell(self, cell: Cell):
        cell.splitlines(self._max_len)
        self._cells.append(cell)

    def render(self) -> str:
        output = colorama.Style.BRIGHT
        output += f'{self._top_rule()}\n'
        for cell in self._cells:
            for line in cell.lines:
                output += f'║{line.render()}{" " * (self._max_len - len(line))}║\n'
            if cell != self._cells[-1]:
                output += f'{self._middle_rule()}\n'
        output += f'{self._bottom_rule()}\n'
        output += colorama.Style.RESET_ALL
        return output


def main(max_len: int = 60):
    generator = MotDGenerator(max_len)
    generator.add_cell(Cell('大家好！为了提高服务器计算资源的流转效率，更好的为大家的科研工作服务，现提供《南开大学软件学院服务器作业管理平台》'
                            '进一步规范服务器的管理和使用。平台地址为：\n┌───────────────────────┐\n│  http://10.10.1.210/  │\n└'
                            '───────────────────────┘\n该平台主要提供服务器状态查询和作业登记管理功能。请各位用户在服务器上执行任务前先'
                            '在该平台进行作业信息登记。'))
    generator.add_cell(Cell('请注意：未在该平台登记的服务器作业可能被清理（SIGTERM）。',
                            color=colorama.Fore.YELLOW))
    generator.add_cell(Cell('请务必准确填写和及时更新 PID。\n该平台每隔30分钟会清理一次未登记或过期的 GPU 进程。',
                            color=colorama.Fore.RED))
    motd_string = generator.render()
    print(motd_string)
    with open('motd', 'w') as motd:
        motd.write(motd_string)


if __name__ == '__main__':
    colorama.init()
    fire.Fire(main)
