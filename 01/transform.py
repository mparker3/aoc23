import re

nums_to_words = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}



def main():
    for line in open('input.txt', 'r'):
        result = ""
        i = 0
        while i < len(line):
            for word in nums_to_words.keys():
                if line[i:].startswith(word):
                    result += nums_to_words[word]
                    break
            if line[i].isdigit():
                result += line[i]
            i += 1  # Always move forward one character
        print(result)

if __name__ == '__main__':
    main()
