import sys
from ged4py.parser import GedcomReader

path = "shakespeare.ged"
file = open('my_kp.pl', 'w')
parser = GedcomReader(path)

with GedcomReader(path, encoding="utf-8") as parser:
    for n, human in enumerate(parser.records0("INDI")):
        mother = human.mother
        if mother:
            file.write("mother('" + mother.name.format() + "','" + human.name.format() + "'). \n")
    for n, human in enumerate(parser.records0("INDI")):
        father = human.father
        if father:
            file.write("father('" + father.name.format() + "','" + human.name.format() + "'). \n")
file.close()
