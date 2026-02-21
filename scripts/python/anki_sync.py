import json
import sys
import urllib.request


def invoke(action, **params):
    request_data = json.dumps({
        "action": action,
        "params": params,
        "version": 6
    })
    try:
        response = urllib.request.urlopen(
            urllib.request.Request(
                "http://localhost:8765",
                request_data.encode("utf-8")
            )
        )
        return json.load(response)
    except Exception as e:
        print(f"Error connecting to AnkiConnect: {e}")
        sys.exit(1)


def sync():
    if len(sys.argv) < 4:
        sys.exit(1)
    # Ignoring DB path arg for API mode
    _, deck_name, file_path = sys.argv[1:]

    with open(file_path, "r") as f:
        content = f.read().split("---")

    cards_added = 0
    for card in content:
        if "?" in card:
            parts = [part.strip() for part in card.split("?", 1)]
            if len(parts) < 2:
                continue
            front, back = parts

            note = {
                "deckName": deck_name,
                "modelName": "Basic",
                "fields": {
                    "Front": front,
                    "Back": back
                },
                "options": {
                    "allowDuplicate": False
                },
                "tags": ["obsidian-sync"]
            }

            result = invoke("addNote", note=note)
            if result.get("error") is None:
                cards_added += 1

    print(f"Cards processed. New cards added: {cards_added}")


if __name__ == "__main__":
    sync()
