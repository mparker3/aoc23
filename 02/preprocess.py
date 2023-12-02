def main():
    with open("input.txt", "r") as f:
        while text := f.readline():
            game_number = text.split(":")[0].split(" ")[1]
            turns = text.split(":")[1].split(";")
            # TODO(mparker): deal with leading/trailing whitespace
            turns = [turn.strip() for turn in turns]
            for turn in turns:
                colors = turn.split(", ")
                # manually create each color, don't get fancy
                reds, blues, greens = 0, 0, 0
                for color in colors:
                    if 'red' in color:
                        reds += int(color.split(" ")[0])
                    elif 'blue' in color:
                        blues += int(color.split(" ")[0])
                    elif 'green' in color:
                        greens += int(color.split(" ")[0])
                print(f"{game_number}, {reds}, {greens}, {blues}")
                        





if __name__ == "__main__":
    main()
