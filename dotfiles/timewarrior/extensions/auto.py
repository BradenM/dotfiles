#!/usr/bin/env python3.8

import tw
from enum import auto, Flag


class Tags(Flag):
    _missing_ = lambda k: None
    MEETING = auto()
    CRISISCLEANUP = auto()

    CCMEETING = MEETING | CRISISCLEANUP



AUTO_DESC = {
    Tags.CCMEETING: 'Weekly Crisis Cleanup Meeting'
}

if __name__ == '__main__':
    _, data = tw.parse_input(process=True)
    for entry in data:
        tag_vals = sum([Tags[t.upper()].value for t in entry['tags'] if t.upper() in Tags.__members__])
        if tag_vals:
            auto_tag = Tags(tag_vals)
            auto_desc = AUTO_DESC.get(auto_tag, None)
            if auto_desc and 'annotation' not in entry:
                print(f'\nAuto Data found for entry: {auto_tag} -> {entry["id"]}')
                print('Updating Annotation:', auto_desc)
                #tw.annotate_entry(entry['id'], auto_desc)
            
