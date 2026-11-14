#!/usr/bin/env bash
input=$(cat)
mkdir -p "$CLAUDE_PROJECT_DIR/docs/ai"
{
  echo "### $(date '+%Y-%m-%d %H:%M') · session $(echo "$input" | jq -r .session_id | cut -c1-8)"
  echo
  echo "$input" | jq -r .prompt
  echo
} >> "$CLAUDE_PROJECT_DIR/docs/ai/prompts.md"
