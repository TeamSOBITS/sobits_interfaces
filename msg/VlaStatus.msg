# Status of a sobits_vla_tools stage node, published on ~/status:
#   /<robot>/vla_rosbag_collection/status  (recorder, STAGE_COLLECTION)
#   /<robot>/sobits_vla_deploy/status      (deploy,   STAGE_DEPLOY)
# A 1 Hz heartbeat (event = EVENT_NONE) plus one message immediately on every transition.

uint8 STAGE_COLLECTION=0
uint8 STAGE_DEPLOY=1

# Same numbers as VlaCommand.Response STATE_*; RESETTING is status-only.
uint8 STATE_STOPPED=0
uint8 STATE_RECORDING=1
uint8 STATE_PAUSED=2
uint8 STATE_PLAYING=3
uint8 STATE_ERROR=4
uint8 STATE_RESETTING=5

uint8 EVENT_NONE=0          # heartbeat, nothing new since the last event
uint8 EVENT_STARTED=1       # recording / playing began
uint8 EVENT_PAUSED=2
uint8 EVENT_RESUMED=3
uint8 EVENT_SAVED=4
uint8 EVENT_DISCARDED=5     # detail: "too_short" | "integrity_failed"
uint8 EVENT_DELETED=6
uint8 EVENT_ERROR=7         # detail: error text
uint8 EVENT_TASK_SET=8      # detail: task name
uint8 EVENT_REJECTED=9      # a command was refused; detail: reason; state unchanged
uint8 EVENT_STOPPED=10      # deploy: PLAY ended, world reset starting; outcome set
uint8 EVENT_EPISODE_DONE=11 # deploy: reset after an episode finished (mirrors ~/episode_done); outcome set
uint8 EVENT_ENGAGED=12      # deploy: deadman pressed, actions flowing
uint8 EVENT_RELEASED=13     # deploy: deadman released, robot held
uint8 EVENT_RESET_DONE=14   # deploy: an idle STOP/RESET world reset finished (no episode)

builtin_interfaces/Time stamp
uint8 stage
uint8 state
uint8 event
uint32 event_seq            # increments once per event, not per heartbeat
bool task_set               # false until the task was set once
string task_name            # "" while task_set is false
string episode_name         # recorder: bag name (episode_<ts>); deploy: episode_<n> of this process
float32 elapsed_sec         # recorder: recorded time, pauses excluded, frozen while paused.
                            # deploy: the node's episode clock (from PLAY, or from the first
                            # deadman engagement), frozen at stop. Keeps the final value after.
string detail               # event payload, see EVENT_* comments
string message              # human-readable. recorder: "idle" | "recording HH:MM:SS" | "paused HH:MM:SS" |
                            # "error" | "saved" | "discarded" | "deleted" | "task_set: <name>".
                            # deploy: "idle" | "playing HH:MM:SS" | "playing HH:MM:SS (released)" |
                            # "resetting" | "done: <outcome>" | "error"

# Deploy stage only (zero / empty from the recorder)
string policy               # model.repo_id ("fake" in the dry run)
bool deadman_enabled
bool deadman_engaged
uint32 steps                # control steps executed in this episode
float32 inference_hz        # action-chunk inferences per second (rolling window); 0 when idle
string outcome              # manual_stop | success_lift | success_place | fallen | timeout | dropped | reset;
                            # set with EVENT_STOPPED / EVENT_EPISODE_DONE, "" while playing
