import fire
import json
import urwid
import colorama

COLORS = {
    'black': colorama.Fore.BLACK,
    'red': colorama.Fore.RED,
    'green': colorama.Fore.GREEN,
    'yellow': colorama.Fore.YELLOW,
    'blue': colorama.Fore.BLUE,
}


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

    def __init__(self, text: str, color: str | None = None):
        self.text = text
        self.color = color

    def render(self) -> str:
        return f'{set_color(self.color)}{self.text}{set_color()}'

    def __len__(self) -> int:
        return sum([char_len(char) for char in self.text])


class Cell:

    def __init__(self, text: str, color: str | None = None):
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


def main(config: str = 'server-hub.json'):
    with open(config, 'r', encoding='utf-8') as f:
        config = json.load(f)
    generator = MotDGenerator(config.get('max_length', 60))
    for cell_config in config['cells']:
        generator.add_cell(Cell(cell_config['text'], COLORS.get(cell_config.get('color'))))
    motd_string = generator.render()
    print(motd_string)
    with open('motd', 'w', encoding='utf-8') as motd:
        motd.write(motd_string)


if __name__ == '__main__':
    colorama.init()
    fire.Fire(main)
