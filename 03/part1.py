def main():
    nums_to_include = []

    nums = []
    with open("input.txt", "r") as f:
        lines = [l.strip() for l in f]
        for i in range(len(lines)):
            for j in range(len(lines[i])):
                if lines[i][j] != "." and not lines[i][j].isnumeric():
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
                                    nums_to_include.append((i + k, j + l))
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
                    # add the number and its position to nums_to_include
                    for k in range(len(num)):
                        if (i, j - len(num) + k) in nums_to_include:
                            nums.append(int(num))
                            break
                j += 1
    print(sum(nums))


if __name__ == "__main__":
    main()
