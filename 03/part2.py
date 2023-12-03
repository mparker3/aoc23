from collections import defaultdict


def main():
    pos_by_gear = defaultdict(list)
    gears_by_pos = defaultdict(list)
    nums_by_gear = defaultdict(list)

    nums = []
    with open("input.txt", "r") as f:
        lines = [l.strip() for l in f]
        for i in range(len(lines)):
            for j in range(len(lines[i])):
                if lines[i][j] == "*":  # gears only this time
                    # check "around" the character for numbers. include diagonals.
                    for k in range(-1, 2):
                        for l in range(-1, 2):
                            if (
                                i + k >= 0
                                and i + k < len(lines)
                                and j + l >= 0
                                and j + l < len(lines[i])
                            ):
                                if lines[i + k][j + l].isnumeric():
                                    pos_by_gear[(i, j)].append((i + k, j + l))
                                    gears_by_pos[(i + k, j + l)].append((i, j))

        # iterate through all lines. get the positions for each number, where the number is a digit or sequence of digits
        # i.e. in line ".....123", we want the a) the number 123 and b) the position of each digit in 123.
        # horizontal nums only.
        for i in range(len(lines)):
            j = 0
            while j < len(lines[i]):
                if lines[i][j].isnumeric():
                    # check if the number is 2 digits or more
                    num = ""
                    while j < len(lines[i]) and lines[i][j].isnumeric():
                        num += lines[i][j]
                        j += 1

                    # check if any of the positions in the number are by a gears
                    for k in range(len(num)):
                        if (i, j - len(num) + k) in gears_by_pos.keys():
                            # if so, add the number to the list of numbers for that gear
                            gear_idx = gears_by_pos[(i, j - len(num) + k)]
                            for gear in gear_idx:
                                nums_by_gear[gear].append(int(num))
                            break
                j += 1
    sum_ratio = 0
    for maybe_ratio in nums_by_gear.keys():
        if len(nums_by_gear[maybe_ratio]) == 2:
            sum_ratio += nums_by_gear[maybe_ratio][0] * nums_by_gear[maybe_ratio][1]
    print(sum_ratio)


if __name__ == "__main__":
    main()
