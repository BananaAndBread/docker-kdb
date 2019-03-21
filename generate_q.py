import argparse
import os
import urllib3


dbs = {
    'actor': 'ISSP',
    'address': 'ISSSISSP',
    'category': 'ISP',
    'city': 'ISIP',
    'country': 'ISP',
    'customer': 'IISSSIBPPI',
    'film': 'ISSIIIFIFSPSS',
    'film_actor': 'IIP',
    'film_category': 'IIP',
    'inventory': 'IIIP',
    'language': 'ISP',
    'payment': 'IIIIFP',
    'rental': 'IPIIPIP',
    'staff': 'ISSISIBSSP',
    'store': 'IIIP'
}


def generate_q():
    lines = []
    for db, types in dbs.items():
        lines.append(f'{db}:("{types}";enlist ",") 0:`:/csv/{db}.csv')
    lines.append('')

    with open('init.q', 'w') as f:
        f.write('\n'.join(lines))


if __name__ == '__main__':
    generate_q()
