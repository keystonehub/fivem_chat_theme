# Keystone - FiveM Chat Theme

### Overview

This is just a straight forward chat theme with a simple, sleek design. 
Chat system includes 11 pre defined chat commands from global chat, to private messages.
Also includes a simple logging system to save and log all messages to json files periodically. 
Relatively easy to create additional chat, just copy paste what currently exists and change a little around. 
Resource is entirely open-source, feel free to edit to your hearts content. 

Enjoy.

### Features

- **Multiple pre-defined chat types:** Various types of rp related chats have been setup for use out of the box.
- **Message logs:** Simple logging system to save and log all messages to json files periodically.
- **Adaptable and Open Source:** Easily adaptable for adding new chat types or modifying existing ones.
- **Multi-Framework Support**: Compatible with various game server frameworks through use of `fivem_utils`.

### Chat Types

- **Global:** Regular chat sent to all players.
- **Local:** Local chat for players within scope.
- **Staff:** Staff messages sent to all players.
- **Staff Only:** Private staff only chat.
- **Advert:** Advertisement messages.
- **Police:** Police messages to all (optional to require on duty before sending).
- **EMS:** Same as police except ems.
- **Warning:** Warning messages can either be sent to all or can be directly pm'd to a specific player.
- **PM:** Private messages player -> player.
- **Trade:** Trade chat messages sent to all players.

### Dependencies

- `chat`
- `fivem_utils` 

### Script installation

1. Customisation:

- Customise `server/config.lua` to suite your requirements.
- Customise `server/language/en.lua` to suite your requirements, or create a new language file and start your translation from the `fxmanifest.lua`.
- Customise the `:root` section at the **TOP** of `html/css/styles.css` to modify the colours used. To modify any more you have to experiment with the CSS *(you can live preview this by opening the provided html file within a browser)*.

2. Installation:

- Drag and drop `fivem_chat_theme` into your server resources.
- **IMPORTANT** Add `ensure fivem_chat_theme` into your `server.cfg` ensuring it is placed after `fivem_utils`. 
- If you have any problems with framework related actions then ensure `fivem_chat_theme` is also placed below your core folder *(this should not be required anymore due to recent utils updates however if have issues its worth doing)*.

## 📝 Documentation

A official documentation section has not been setup for Keystone yet. 

## 📩 Support

Support for Keystone resources is primarily handled by the community.
Please do not join the discord expecting instant support. 

This is a **free** and **open source** resource after all. 

https://discord.gg/SjNhQV2YeN