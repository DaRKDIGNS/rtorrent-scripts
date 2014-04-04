<?php
// This script will start multiple rtorrent sessions and shutdown each
// session before terminating.
// rtorrent itself can handle many 1000's of torrent, not all active at once, of course
// but rutorrent, even stripped down and using httprpc can not handle more than a few hundred
// without noticeable slowness. I wrote this to allow me to run any number of instances,
// just keep adding the session info

// To use with cron:
// crontab -e
// */10 * * * *  /usr/bin/php /home/[user_name]/start_rtorrent.php cron

// If you have a functioning email, email will be sent to notify
// restarting of any rtorrent session only

if (!isset($argv[1]) || ($argv[1] !== "exit" && $argv[1] !== "kill" && $argv[1] !== "start" && $argv[1] !== "cron")) {
	exit("\nThis script will start multiple rtorrent sessions.\n\n"
		. "php $argv[0] start    ...: To start all rtorrent sessions.\n"
		. "php $argv[0] cron     ...: To start all rtorrent sessions but not attach to the tmux session.\n"
		. "php $argv[0] kill     ...: To close all rtorrent sessions but leave tmux session running.\n"
		. "php $argv[0] exit     ...: To close all rtorrent sessions and close the tmux session.\n");
}

// Start tmux server
exec("tmux start-server");

// set session name
$tmux_session = "rtorrent";

//check if session exists
$exec = exec("tmux list-session | grep $tmux_session", $session);
if (count($session) !== 0) {
	// If there is a tmux session already
	if ($argv[1] === "kill" || $argv[1] === "exit") {
		// Tell rtorrent to close the session
		exec("tmux send-keys -t $tmux_session:0 C-q");
		exec("tmux send-keys -t $tmux_session:1 C-q");
		exec("tmux send-keys -t $tmux_session:2 C-q");
		exec("tmux send-keys -t $tmux_session:3 C-q");
		exec("tmux send-keys -t $tmux_session:4 C-q");
		$dead = false;
		echo "Waiting for rtorrent sessions to terminate.\n";
		while ($dead === false) {
			if (shell_exec("tmux list-panes -t $tmux_session:0 | grep -c dead") == 1) {
				if (shell_exec("tmux list-panes -t $tmux_session:1 | grep -c dead") == 1) {
					if (shell_exec("tmux list-panes -t $tmux_session:2 | grep -c dead") == 1) {
						if (shell_exec("tmux list-panes -t $tmux_session:3 | grep -c dead") == 1) {
							if (shell_exec("tmux list-panes -t $tmux_session:4 | grep -c dead") == 1) {
								$dead = true;
							}
						}
					}
				}
			}
			if ($dead === false) {
				sleep(10);
				echo ".";
			}
		}
		echo "\nAll rtorrent sessions terminated.\n";
		if ($argv[1] === "exit") {
			exec("tmux kill-session -t $tmux_session");
			exit("\ntmux session $tmux_session has been terminated.\n\n");
		}
		exit();
	} else {
		// restart rtorrent sessions if dead
		if (shell_exec("tmux list-panes -t $tmux_session:0 | grep -c dead") == 1) {
			echo "$tmux_session:0 appears to be dead, restarting\n";
			exec("tmux respawnp -t $tmux_session:0 'rtorrent -n -o import=~/.rtorrent.rc'");
		}
		if (shell_exec("tmux list-panes -t $tmux_session:1 | grep -c dead") == 1) {
			echo "$tmux_session:1 appears to be dead, restarting\n";
			exec("tmux respawnp -t $tmux_session:1 'rtorrent -n -o import=~/.rtorrent-1.rc'");
		}
		if (shell_exec("tmux list-panes -t $tmux_session:2 | grep -c dead") == 1) {
			echo "$tmux_session:2 appears to be dead, restarting\n";
			exec("tmux respawnp -t $tmux_session:2 'rtorrent -n -o import=~/.rtorrent-2.rc'");
		}
		if (shell_exec("tmux list-panes -t $tmux_session:3 | grep -c dead") == 1) {
			echo "$tmux_session:3 appears to be dead, restarting\n";
			exec("tmux respawnp -t $tmux_session:3 'rtorrent -n -o import=~/.rtorrent-3.rc'");
		}
		if (shell_exec("tmux list-panes -t $tmux_session:4 | grep -c dead") == 1) {
			echo "$tmux_session:4 appears to be dead, restarting\n";
			exec("tmux respawnp -t $tmux_session:4 'rtorrent -n -o import=~/.rtorrent-4.rc'");
		}
		if (shell_exec("tmux list-panes -t $tmux_session:8 | grep -c dead") == 1) {
			if ((isset($argv[1]) && $argv[1] !== "cron") || !isset($argv[1])) {
				exec("tmux respawnp -t $tmux_session:8 'chromium-browser'");
			}
		}
		if ($argv[1] === "start") {
			exec("tmux a -t $tmux_session");
		}
	}
} else {
	if ($argv[1] === "kill") {
		exit("\nThere is no tmux session running and therefore there are no rtorrent sessions to terminate.\n\n");
	} elseif ($argv[1] === "exit") {
		exit("\nThere is no tmux session to terminate.\n\n");
	} else {
		exec("tmux -f ~/.tmux.conf new-session -d -s $tmux_session -n 0 'rtorrent -n -o import=~/.rtorrent.rc'");
		exec("tmux new-window -t $tmux_session:1 -n 1 'rtorrent -n -o import=~/.rtorrent-1.rc'");
		exec("tmux new-window -t $tmux_session:2 -n 2 'rtorrent -n -o import=~/.rtorrent-2.rc'");
		exec("tmux new-window -t $tmux_session:3 -n 3 'rtorrent -n -o import=~/.rtorrent-3.rc'");
		exec("tmux new-window -t $tmux_session:4 -n 4 'rtorrent -n -o import=~/.rtorrent-4.rc'");
		exec("tmux new-window -t $tmux_session:5 -n htop 'htop'");
		exec("tmux new-window -t $tmux_session:6 -n vnstat 'watch -n30 \"vnstat -u && vnstat -i eth0\"'");
		exec("tmux selectp -t 0; tmux splitw -t $tmux_session:6 -h -p 50 'vnstat -l'");
		exec("tmux new-window -t $tmux_session:7 -n bash 'bash -i'");
		exec("tmux new-window -t $tmux_session:8 -n chromium 'chromium-browser'");
		if ($argv[1] === "start") {
			exec("tmux select-window -t $tmux_session:7; tmux attach-session -d -t $tmux_session");
		}
	}
}
