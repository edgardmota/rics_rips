class RestrictedCompPart
	new: (n,mink,maxk,a,b) =>
		@n = n
		@mink = mink
		@maxk = maxk
		@a = a
		@b = b
	print_cell: (cell,level,row) =>
		str = ""
		for item in *cell
			str = "#{str}#{item} "
		print "#{str}"
	node2node: (comp_part,i,row,col,level,cum_sum_parts,a) =>
		cell = {}
		for i = 1, level + 1
			cell[i] = a
		if col != 0
			high = math.min @b, @n - cum_sum_parts - a
			low = math.max a, @n - cum_sum_parts - @b
			if comp_part
				high = high - math.floor (high - low + 1)/2
			if col == 1
				for j = low, high
					cell[i - 1] = j
					cell[i] = @n - cum_sum_parts - j
					@print_cell cell, level, row
			else
				cell[level + 1] = a
				cum_sum_parts_temp = cum_sum_parts + a
				aux = ((@n - cum_sum_parts_temp)/(i - level - 1))
				if (a <= aux) and (aux <= @b) and (cell[level+1] <= @b)
					@node2node comp_part, i,row - a + 1, col - 1, level + 1, cum_sum_parts_temp, a
				else
					for q = 1, (math.min @b - a, (row - a) - (col - 1) )
						cell[level + 1] = cell[level + 1] + 1
						if comp_part
							a += 1
						cum_sum_parts_temp += 1
						aux = ((@n - cum_sum_parts_temp)/(i - level - 1))
						if (a <= aux) and (aux <= @b) and (cell[level+1] <= @b)
							q2 = q
							q = math.min @b - a, (row - a) - (col - 1)
							@node2node comp_part, i,row - a + 1 - q2, col - 1, level + 1, cum_sum_parts_temp, a
		else
			print @n
		if (level > 0) and row > 1
			cell[level] += 1
			if comp_part
				a += 1
			cum_sum_parts += 1
			if cell[level] < a
				cum_sum_parts = cum_sum_parts + (a - cell[level])
				cell[level] = a
				row = row - (a - cell[level])
			toploop = math.min @b - cell[level], row - 1 - col
			aux = (@n - cum_sum_parts)/(i - level)
			if (a <= aux) and (aux <= @b) and (cell[level] <= @b)
				@node2node comp_part, i,row - 1, col, level, cum_sum_parts, a
			else
				for p = 1, toploop
					cell[level] += 1
					if comp_part
						a += 1
					cum_sum_parts += 1
					aux = (@n - cum_sum_parts)/(i - level)
					if (a <= aux) and (aux <= @b) and (cell[level] <= @b)
						p2 = p
						p = toploop
						@node2node comp_part, i,row - p2, col, level, cum_sum_parts, a
	rics_rips: (comp_part) =>
		rowdec = 0
		for i = @mink, @maxk
			if @a != 1
				rowdec = i
			aux = (@n/i)
			if (@a <= aux) and (aux <= @b)
				@node2node comp_part, i, @n - 1 - rowdec, i - 1, 0, 0, @a
