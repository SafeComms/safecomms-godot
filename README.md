# SafeComms Godot SDK

Official Godot addon for the SafeComms Content Moderation API.

## Installation

1. Copy the `addons/safecomms` folder into your Godot project's `addons/` directory.
2. Go to **Project > Project Settings > Plugins**.
3. Enable the **SafeComms** plugin.

## Usage

The plugin adds a global `SafeComms` singleton to your project.

### Configuration

In your main scene or a setup script, configure the API key:

```gdscript
func _ready():
    SafeComms.api_key = "your-api-key"
    SafeComms.base_url = "https://api.safecomms.dev" # Optional, defaults to production
```

### Moderating Text

```gdscript
func _on_send_message_pressed():
    var text = $LineEdit.text
    
    var result = await SafeComms.moderate_text(text)
    
    if result.has("flagged") and result.flagged:
        print("Message blocked: ", result.reason)
    else:
        send_message(text)
```
