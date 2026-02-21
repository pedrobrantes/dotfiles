import sqlite3
import sys
import time


def sync():
    if len(sys.argv) < 4:
        sys.exit(1)
    db_path, deck_name, file_path = sys.argv[1:]
    conn = sqlite3.connect(db_path)

    def collate(a, b):
        return (a.lower() > b.lower()) - (a.lower() < b.lower())

    conn.create_collation('unicase', collate)
    cur = conn.cursor()

    cur.execute('SELECT id FROM decks WHERE name = ?', (deck_name,))
    row = cur.fetchone()
    if row:
        deck_id = row[0]
    else:
        deck_id = int(time.time() * 1000)
        cur.execute(
            'INSERT INTO decks (id, name, mtime, usn, conf, rev) '
            'VALUES (?, ?, ?, -1, 1, 0)',
            (deck_id, deck_name, int(time.time()))
        )

    with open(file_path, 'r') as f:
        content = f.read().split('---')

    for card in content:
        if '?' in card:
            parts = [part.strip() for part in card.split('?', 1)]
            if len(parts) < 2:
                continue
            front, back = parts
            flds = front + '\x1f' + back
            guid = str(abs(hash(flds)))[:10]
            try:
                ts = int(time.time() * 1000)
                cur.execute(
                    'INSERT INTO notes '
                    '(id, guid, mid, mod, usn, tags, flds, sfld, '
                    'csum, flags, data) '
                    'VALUES (?, ?, ?, ?, -1, ?, ?, ?, 0, 0, ?)',
                    (ts, guid, 1, int(time.time()), "", flds, front, "")
                )
                nid = cur.lastrowid
                cur.execute(
                    'INSERT INTO cards '
                    '(id, nid, did, ord, mod, usn, type, queue, '
                    'due, ivl, factor, reps, lapses, left, odue, '
                    'odid, flags, data) '
                    'VALUES (?, ?, ?, 0, ?, -1, 0, 0, 0, 0, 0, 0, '
                    '0, 0, 0, 0, 0, "")',
                    (ts + 1, nid, deck_id, int(time.time()))
                )
            except sqlite3.Error:
                continue
    conn.commit()
    conn.close()


if __name__ == "__main__":
    sync()
