import sqlite3
import sys


def view():
    if len(sys.argv) < 3:
        sys.exit(1)

    db_path, deck_name = sys.argv[1:]

    def collate(a, b):
        return (a.lower() > b.lower()) - (a.lower() < b.lower())

    conn = sqlite3.connect(f'file:{db_path}?mode=ro', uri=True)
    conn.create_collation('unicase', collate)
    cur = conn.cursor()

    # Using a single-line query string to avoid escape issues in the Nix store
    query = (
        "SELECT n.flds FROM notes n "
        "JOIN cards c ON n.id = c.nid "
        "JOIN decks d ON c.did = d.id "
        "WHERE d.name = ?"
    )

    cur.execute(query, (deck_name,))

    for row in cur.fetchall():
        # Anki fields are separated by 0x1f
        content = row[0].replace('\x1f', '\n--- BACK ---\n')
        print(content)
        print("-" * 40)

    conn.close()


if __name__ == "__main__":
    view()
