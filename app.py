#!/usr/bin/env python3

from os import system
from random import randint, random
from time import sleep

MAX_COMMITS = 2

def commit():
    system("git checkout bot")
    system("echo $(date) >> output.txt")
    system("git stage output.txt")
    system("git commit -m 'Update output.txt'")
    system("git push")

if __name__ == "__main__":
    for i in range(randint(1, MAX_COMMITS)):
        commit()
        sleep(random() * 10.0)
