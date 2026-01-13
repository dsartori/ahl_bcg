# Basic Computer Games
Original programs of the book "BASIC Computer Games"

This is an unofficial mirror of the source code provided inside the book **"Basic Computer Games"**, aka **"101 BASIC Computer Games"**, by David H. Ahl, published in 1978.

The games are meant to run with Vintage BASIC, but if you are able to use them with other interpreters be my guest. Having Caps-Lock on is advisable, as the games were designed to work with capital letters.

## Fork Purpose

This fork adds a little infrastructure to make these classic games more accessible, and has some interesting ports:

- **Docker Infrastructure**: Run the original BASIC games in a containerized environment with PC-BASIC interpreter
- **Ports Folder**: Modern language implementations of the games 
- **Goal**: Preserve these historic games while making them playable on modern systems

## Usage

### Running Original BASIC Games with Docker

1. Build the Docker image:
   ```bash
   docker build -t basic .
   ```

2. Run a game:
   ```bash
   docker run --rm -it basic animal.bas
   ```

3. List available games:
   ```bash
   docker run --rm -it basic
   ```

### Running Modern Ports

Python implementations are available in the `ports/` folder:

```bash
python ports/animal.py
```

## Disclaimer

I wasn't the one who compiled this repository, I'm just mirroring it. Here's the origin:
http://vintage-basic.net/games.html
