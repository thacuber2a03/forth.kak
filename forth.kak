colorscheme default

provide-module -override forth %{
	add-highlighter shared/forth regions
	add-highlighter shared/forth/line_comment region '\\' '$' fill comment
	add-highlighter shared/forth/block_comment region '\( ' '\)' fill comment
	add-highlighter shared/forth/ region '[.SC]" ' '"' fill string
	add-highlighter shared/forth/ region 'S\\" ' '"' fill string
	add-highlighter shared/forth/ region 'ABORT" ' '"' fill string
	add-highlighter shared/forth/ region 'BREAK" ' '"' fill string

	add-highlighter shared/forth/code default-region group

	# I don't know enough Bash so if anyone could help me with all this that'd be great

	evaluate-commands %sh{
		keywords='vocabulary variable value create does\> constant field char if then to field begin while repeat
		          case of endof endcase do \\?do loop else again until immediate quit exit \\[ \\] defer is'

		values='i j tib \#in \>in RP0 SP0 base state abort'

		functions='allot decimal hex pick rp@ sp@ type word count find u\\. n\\. d\\. u\\.r \\.r refill spaces space
		           emit key interpret'

		operators='1\\+ \\+ 1- - \\\* 2\\\* 4\\\* 8\\\* 2/ / r@ @ \\+! -! ! 2@ 2r@ 2\\+! 2-! 0= 0\< 0\> 0\<\> 0\< 0\>
		           \# r\> \>r 2r\> 2\>r negate invert /mod u/mod um/mod mod max min abs S\>D defer! defer@ cells
		           cell\\+ drop dup over swap 2drop 2dup 2over 2swap C@ C! C, , '' nip or and xor invert lshift rshift
		           \> \< u\< \\?dup roll rot'

		join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

		printf %s\\n "declare-option str-list forth_static_words $(join "${keywords} ${values} ${functions} ${operators}" ' ')"

		printf %s "
			add-highlighter shared/forth/code/ regex (?i)^($(join "${keywords}" '|'))(?=\s)        0:keyword
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${keywords}" '|'))(?=\s)  0:keyword
			add-highlighter shared/forth/code/ regex (?i)^($(join "${keywords}" '|'))$             0:keyword
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${keywords}" '|'))$       0:keyword
			add-highlighter shared/forth/code/ regex (?i)^($(join "${values}" '|'))(?=\s)          0:value
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${values}" '|'))(?=\s)    0:value
			add-highlighter shared/forth/code/ regex (?i)^($(join "${values}" '|'))$               0:value
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${values}" '|'))$         0:value
			add-highlighter shared/forth/code/ regex (?i)^($(join "${functions}" '|'))(?=\s)       0:function
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${functions}" '|'))(?=\s) 0:function
			add-highlighter shared/forth/code/ regex (?i)^($(join "${functions}" '|'))$            0:function
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${functions}" '|'))$      0:function
			add-highlighter shared/forth/code/ regex (?i)^($(join "${operators}" '|'))(?=\s)       0:operator
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${operators}" '|'))(?=\s) 0:operator
			add-highlighter shared/forth/code/ regex (?i)^($(join "${operators}" '|'))$            0:operator
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${operators}" '|'))$      0:operator
		"
	}

	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)(TRUE|FALSE|BL|PI|CELL|C/L|R/O|W/O|R/W)(?=\s)" 0:builtin
	add-highlighter shared/forth/code/ regex "(?i)^(TRUE|FALSE|BL|PI|CELL|C/L|R/O|W/O|R/W)(?=\s)"       0:builtin
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)(TRUE|FALSE|BL|PI|CELL|C/L|R/O|W/O|R/W)$"      0:builtin
	add-highlighter shared/forth/code/ regex "(?i)^(TRUE|FALSE|BL|PI|CELL|C/L|R/O|W/O|R/W)$"            0:builtin

	add-highlighter shared/forth/code/ regex "(?i)^:\s+(\S+)(?=\s)"       1:function
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s):\s+(\S+)(?=\s)" 1:function
	add-highlighter shared/forth/code/ regex "(?i)^:\s+(\S+)$"            1:function
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s):\s+(\S+)$"      1:function

	add-highlighter shared/forth/code/ regex "(?i)^\Q[CHAR]\E\s+."       0:value
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)\Q[CHAR]\E\s+." 0:value

	add-highlighter shared/forth/code/ regex "(?i)^\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\](?=\s)"       0:attribute
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\](?=\s)" 0:attribute
	add-highlighter shared/forth/code/ regex "(?i)^\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\]$"            0:attribute
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\]$"      0:attribute

	add-highlighter shared/forth/code/ regex "(?i)^(\[('|COMPILE)\])|POSTPONE\s+\S+(?=\s)"       0:function
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)(\[('|COMPILE)\])|POSTPONE\s+\S+(?=\s)" 0:function
	add-highlighter shared/forth/code/ regex "(?i)^(\[('|COMPILE)\])|POSTPONE\s+\S+$"            0:function
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)(\[('|COMPILE)\])|POSTPONE\s+\S+$"      0:function

	add-highlighter shared/forth/code/ regex "(?i)^'d+'(?=\s)"       0:value
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)'d+'(?=\s)" 0:value
	add-highlighter shared/forth/code/ regex "(?i)^'d+'$"            0:value
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)'d+'$"      0:value
}

hook global BufCreate .+\.(fs|fth|4th)$ %{
	set-option buffer filetype forth
}

hook -group forth-highlighting global WinSetOption filetype=forth %{
	require-module forth
	add-highlighter window/forth ref forth
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/forth
	}
}

hook global WinSetOption filetype=forth %{
	require-module forth

	set-option window static_words %opt{forth_static_words}
}
