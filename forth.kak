provide-module -override forth %{
	add-highlighter shared/forth regions

	add-highlighter shared/forth/ region '^\\(?=\s)'       '$'  fill comment
	add-highlighter shared/forth/ region '(?<=\s)\\(?=\s)' '$'  fill comment

	add-highlighter shared/forth/ region '^\((?=\s)'       '\)' fill comment
	add-highlighter shared/forth/ region '(?<=\s)\((?=\s)' '\)' fill comment

	add-highlighter shared/forth/ region '(?<=\s)[.SC]"(?=\s)' '"(?=\s)' fill string
	add-highlighter shared/forth/ region '(?<=\s)S\\"(?=\s)'   '"(?=\s)' fill string
	add-highlighter shared/forth/ region '(?<=\s)ABORT"(?=\s)' '"(?=\s)' fill string
	add-highlighter shared/forth/ region '(?<=\s)BREAK"(?=\s)' '"(?=\s)' fill string
	add-highlighter shared/forth/ region       '^[.SC]"(?=\s)' '"$'      fill string
	add-highlighter shared/forth/ region       '^S\\"(?=\s)'   '"$'      fill string
	add-highlighter shared/forth/ region       '^ABORT"(?=\s)' '"$'      fill string
	add-highlighter shared/forth/ region       '^BREAK"(?=\s)' '"$'      fill string

	add-highlighter shared/forth/code default-region group

	evaluate-commands %sh{
		keywords='VOCABULARY VARIABLE VALUE CREATE DOES\> CONSTANT FIELD CHAR IF THEN TO FIELD BEGIN WHILE REPEAT
		          CASE OF ENDOF ENDCASE DO \\?DO LOOP \\+LOOP ELSE AGAIN UNTIL QUIT EXIT \\[ \\] DEFER
		          IS MARKER : \\\; \<\# \#\>'

		values='HERE TRUE FALSE BL PI CELL I J TIB \#IN \>IN RP0 SP0 BASE STATE ABORT'

		functions='ALLOT DECIMAL HEX PICK RP@ SP@ TYPE WORD COUNT FIND U\\. N\\. D\\. U\\.R \\.R REFILL SPACES SPACE
		           EMIT KEY INTERPRET CR WITHIN'

		operators='1\\+ \\+ 1- - \\\* 2\\\* 2/ / \\\*/ R@ @ \\+! -! ! 2@ 2R@ 2\\+! 2-! 0= 0\< 0\> 0\<\> 0\< 0\>
		           \# R\> \>R 2R\> 2\>R NEGATE INVERT /MOD \\\*/MOD U/MOD UM/MOD MOD MAX MIN ABS S\>D DEFER! DEFER@ CELLS
		           CELL\\+ DROP DUP OVER SWAP 2DROP 2DUP 2OVER 2SWAP C@ C! C, , '' NIP OR AND XOR INVERT LSHIFT RSHIFT
		           \> \< U\< \\?DUP ROLL ROT'

		builtins='C/L R/O W/O R/W'

		attributes='IMMEDIATE'

		join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

		printf %s\\n "declare-option str-list forth_static_words $(join "${keywords} ${values} ${functions} ${operators} ${builtin}" ' ')"

		printf %s "
			add-highlighter shared/forth/code/ regex (?i)^($(join "${keywords}" '|'))(?=\s)          0:keyword
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${keywords}" '|'))(?=\s)    0:keyword
			add-highlighter shared/forth/code/ regex (?i)^($(join "${keywords}" '|'))$               0:keyword
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${keywords}" '|'))$         0:keyword
			add-highlighter shared/forth/code/ regex (?i)^($(join "${values}" '|'))(?=\s)            0:value
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${values}" '|'))(?=\s)      0:value
			add-highlighter shared/forth/code/ regex (?i)^($(join "${values}" '|'))$                 0:value
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${values}" '|'))$           0:value
			add-highlighter shared/forth/code/ regex (?i)^($(join "${functions}" '|'))(?=\s)         0:function
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${functions}" '|'))(?=\s)   0:function
			add-highlighter shared/forth/code/ regex (?i)^($(join "${functions}" '|'))$              0:function
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${functions}" '|'))$        0:function
			add-highlighter shared/forth/code/ regex (?i)^($(join "${operators}" '|'))(?=\s)         0:operator
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${operators}" '|'))(?=\s)   0:operator
			add-highlighter shared/forth/code/ regex (?i)^($(join "${operators}" '|'))$              0:operator
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${operators}" '|'))$        0:operator
			add-highlighter shared/forth/code/ regex (?i)^($(join "${builtins}" '|'))(?=\s)          0:builtin
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${builtins}" '|'))(?=\s)    0:builtin
			add-highlighter shared/forth/code/ regex (?i)^($(join "${builtins}" '|'))$               0:builtin
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${builtins}" '|'))$         0:builtin
			add-highlighter shared/forth/code/ regex (?i)^($(join "${attributes}" '|'))(?=\s)        0:attribute
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${attributes}" '|'))(?=\s)  0:attribute
			add-highlighter shared/forth/code/ regex (?i)^($(join "${attributes}" '|'))$             0:attribute
			add-highlighter shared/forth/code/ regex (?i)(?<=\s)($(join "${attributes}" '|'))$       0:attribute
		"
	}

	# I don't know enough Bash so if anyone could help me with all this that'd be great

	add-highlighter shared/forth/code/ regex "(?i)^:\s+(\S+)(?=\s)"       1:function
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s):\s+(\S+)(?=\s)" 1:function
	add-highlighter shared/forth/code/ regex "(?i)^:\s+(\S+)$"            1:function
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s):\s+(\S+)$"      1:function

	add-highlighter shared/forth/code/ regex "(?i)^\Q[CHAR]\E\s+\S"       0:value
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)\Q[CHAR]\E\s+\S" 0:value

	add-highlighter shared/forth/code/ regex "(?i)^\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\](?=\s)"       0:attribute
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\](?=\s)" 0:attribute
	add-highlighter shared/forth/code/ regex "(?i)^\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\]$"            0:attribute
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)\[(IF|ELSE|THEN|DEFINED|UNDEFINED)\]$"      0:attribute

	add-highlighter shared/forth/code/ regex "(?i)^((\[('|COMPILE)\])|POSTPONE)\s+(\S+)(?=\s)"       0:attribute
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)((\[('|COMPILE)\])|POSTPONE)\s+(\S+)(?=\s)" 0:attribute
	add-highlighter shared/forth/code/ regex "(?i)^((\[('|COMPILE)\])|POSTPONE)\s+(\S+)$"            0:attribute
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)((\[('|COMPILE)\])|POSTPONE)\s+(\S+)$"      0:attribute

	add-highlighter shared/forth/code/ regex "(?i)^-?\d+(?=\s)"       0:value
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)-?\d+(?=\s)" 0:value
	add-highlighter shared/forth/code/ regex "(?i)^-?\d+$"            0:value
	add-highlighter shared/forth/code/ regex "(?i)(?<=\s)-?\d+$"      0:value
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
