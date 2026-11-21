#!/usr/bin/env bash
# Task/Todo management function

todo() {
	local todo_file="${BUTTERBASH_NOTES_DIR:-$HOME/.tasks}"

	# Create directory if using custom location
	[[ "$todo_file" != "$HOME/.tasks" ]] && mkdir -p "$(dirname "$todo_file")"

	# Initialize file if it doesn't exist
	[ ! -f "$todo_file" ] && touch "$todo_file"

	case "$1" in
	"" | list)
		# List active tasks
		if [ -s "$todo_file" ]; then
			echo "📋 Tasks:"
			local count=1
			while IFS= read -r line; do
				if [[ "$line" == "[ ]"* ]]; then
					echo -e "  \033[1;33m[$count]\033[0m ☐ ${line:4}"
					((count++))
				elif [[ "$line" == "[x]"* ]]; then
					echo -e "  \033[90m[✓] ~~${line:4}~~\033[0m"
				fi
			done <"$todo_file"

			# Count summary (`grep -c` prints 0 but exits 1 on no match)
			local active=$(command grep -c "^\[ \]" "$todo_file" 2>/dev/null || true)
			local done=$(command grep -c "^\[x\]" "$todo_file" 2>/dev/null || true)
			echo -e "\n  \033[90m$active active, $done completed\033[0m"
		else
			echo "No tasks yet. Use 'todo <task>' to add your first task."
		fi
		;;

	done | complete | finish)
		# Mark task as complete
		if [ -z "$2" ]; then
			echo "Usage: todo done <number>"
			return 1
		fi

		local task_num="$2"
		# Validate that task_num is a number
		if ! [[ "$task_num" =~ ^[0-9]+$ ]]; then
			echo "⚠️  Task number must be a number, not '$task_num'"
			echo "Usage: todo done <number>"
			echo "Did you mean: todo \"$1 $task_num\"?"
			return 1
		fi

		local count=1
		local temp_file="$todo_file.tmp"
		local found=false

		while IFS= read -r line; do
			if [[ "$line" == "[ ]"* ]]; then
				if [ "$count" -eq "$task_num" ]; then
					echo "[x] ${line:4} ($(date '+%Y-%m-%d'))" >>"$temp_file"
					echo "✓ Completed: ${line:4}"
					found=true
				else
					echo "$line" >>"$temp_file"
				fi
				((count++))
			else
				echo "$line" >>"$temp_file"
			fi
		done <"$todo_file"

		if [ "$found" = true ]; then
			mv "$temp_file" "$todo_file"
		else
			rm -f "$temp_file"
			echo "Task #$task_num not found"
			return 1
		fi
		;;

	clear | clean)
		# Remove completed (struck-through) tasks
		local temp_file="$todo_file.tmp"
		command grep "^\[ \]" "$todo_file" >"$temp_file" 2>/dev/null || true
		local removed_count=$(command grep -c "^\[x\]" "$todo_file" 2>/dev/null || true)
		mv "$temp_file" "$todo_file"
		echo "🗑️ Cleared $removed_count completed tasks"
		;;

	rm)
		# Remove a specific task
		if [ -z "$2" ]; then
			echo "Usage: todo rm <number>"
			return 1
		fi

		local task_num="$2"
		# Validate that task_num is a number
		if ! [[ "$task_num" =~ ^[0-9]+$ ]]; then
			echo "⚠️  Task number must be a number, not '$task_num'"
			echo "Usage: todo rm <number>"
			return 1
		fi

		local count=1
		local temp_file="$todo_file.tmp"
		local found=false

		while IFS= read -r line; do
			if [[ "$line" == "[ ]"* ]]; then
				if [ "$count" -eq "$task_num" ]; then
					echo "✗ Removed: ${line:4}"
					found=true
				else
					echo "$line" >>"$temp_file"
				fi
				((count++))
			else
				echo "$line" >>"$temp_file"
			fi
		done <"$todo_file"

		if [ "$found" = true ]; then
			mv "$temp_file" "$todo_file"
		else
			rm -f "$temp_file"
			echo "Task #$task_num not found"
			return 1
		fi
		;;

	help)
		echo "Usage:"
		echo "  todo              - List active tasks (completed shown struck-through)"
		echo "  todo <task>       - Add a new task"
		echo "  todo done <n>     - Mark task #n as complete (strikethrough)"
		echo "  todo rm <n>       - Delete task #n completely"
		echo "  todo clear        - Remove struck-through completed tasks"
		echo "  todo help         - Show this help"
		;;

	*)
		# Add new task
		echo "[ ] $*" >>"$todo_file"
		echo "✓ Added: $*"
		;;
	esac
}
