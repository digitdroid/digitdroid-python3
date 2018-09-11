import os

filename = '/tmp/%s' % os.path.basename(os.path.abspath(__file__))

with open(filename, 'w') as file:
    file.write('!')
