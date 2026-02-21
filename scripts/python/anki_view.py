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


def view():
    if len(sys.argv) < 3:
        sys.exit(1)

    # Ignoring DB path arg for API mode
    _, deck_name = sys.argv[1:]

    query = f'deck:"{deck_name}"'
    result = invoke("findNotes", query=query)
    note_ids = result.get("result", [])

    if not note_ids:
        print(f"No cards found in deck: {deck_name}")
        return

    notes_info = invoke("notesInfo", notes=note_ids)
    notes = notes_info.get("result", [])

    for note in notes:
        fields = note.get("fields", {})
        front = fields.get("Front", {}).get("value", "N/A")
        back = fields.get("Back", {}).get("value", "N/A")

        print(f"{front}")
        print("--- BACK ---")
        print(f"{back}")
        print("-" * 40)


if __name__ == "__main__":
    view()
