# Recorder status of sobits_vla_rosbag_collection, published on ~/record_status
# (resolves to /<robot>/vla_rosbag_collection/record_status): a 1 Hz heartbeat
# (event = EVENT_NONE) plus one message immediately on every transition.

# Same numbers as VlaCommand.Response STATE_* so clients can copy the value.
uint8 STATE_STOPPED=0
uint8 STATE_RECORDING=1
uint8 STATE_PAUSED=2
uint8 STATE_ERROR=4

uint8 EVENT_NONE=0        # heartbeat, nothing new since the last event
uint8 EVENT_STARTED=1
uint8 EVENT_PAUSED=2
uint8 EVENT_RESUMED=3
uint8 EVENT_SAVED=4
uint8 EVENT_DISCARDED=5   # detail: "too_short" | "integrity_failed"
uint8 EVENT_DELETED=6
uint8 EVENT_ERROR=7       # detail: error text
uint8 EVENT_TASK_SET=8    # detail: task name
uint8 EVENT_REJECTED=9    # a command was refused; detail: reason; state unchanged

builtin_interfaces/Time stamp
uint8 state
uint8 event
uint32 event_seq          # increments once per event, not per heartbeat
bool task_set             # false until vla_task_update succeeded once
string task_name          # "" while task_set is false
string episode_name       # current/last bag name (episode_<ts>), "" before the first RECORD
float32 elapsed_sec       # recorded time of the episode, pauses excluded; frozen while
                          # paused; keeps the final value after save/discard/delete
string detail             # event payload, see EVENT_* comments
string message            # human-readable: "idle" | "recording HH:MM:SS" | "paused HH:MM:SS" |
                          # "error" | "saved" | "discarded" | "deleted" | "task_set: <name>"
