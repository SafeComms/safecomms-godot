# SafeComms Godot SDK

Official Godot addon for the SafeComms Content Moderation API.

SafeComms is a powerful content moderation platform designed to keep your digital communities safe. It provides real-time analysis of text to detect and filter harmful content, including hate speech, harassment, and spam.

**Get Started for Free:**
We offer a generous **Free Tier** for all users, with **no credit card required**. Sign up today and start protecting your community immediately.

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
