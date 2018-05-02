# Ruby Assignment Code Skeleton
# Nigel Ward, University of Texas at El Paso
# April 2015
# borrowing liberally from Gregory Brown's tic-tac-toe game
#------------------------------------------------------------------
class Board
  def initialize
  @board = [[nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,nil,nil,nil,nil]]
  end

  # process a sequence of moves, each just a column number
  def addDiscs(firstPlayer, columns)
    if firstPlayer == :R
      players = [:R, :O].cycle
    else 
      players = [:O, :R].cycle
    end
    columns.each {|c| addDisc(players.next, c)}
  end 

  def addDisc(player, column)
    if column >= 7 || column < 0
      puts "  addDisc(#{player},#{column}): out of bounds"
      return false   
    end
	# Find the bottom-most row available with rindex
    bottomMostFreeRow =  @board.transpose.slice(column).rindex(nil)
    if bottomMostFreeRow == nil  
      puts "  addDisc(#{player},#{column}): column full already"
      return false 
    end
    update(bottomMostFreeRow, column, player)
    return true
  end

  def update(row, col, player)
    @board[row][col] = player
  end

  def print
    puts @board.map {|row| row.map { |e| e || " "}.join("|")}.join("\n")
    puts "\n"
  end

  def hasWon? (player)
    return verticalWin?(player)| horizontalWin?(player) | 
           diagonalUpWin?(player)| diagonalDownWin?(player)
  end 

  # The following methods check if the player has won vertically, horizontally, etc.
  def verticalWin? (player)
    (0..6).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 0)}}
  end

  def horizontalWin? (player)
    (0..3).any? {|c| (0..5).any? {|r| fourFromTowards?(player, r, c, 0, 1)}}
  end

  def diagonalUpWin? (player)
    (0..3).any? {|c| (0..2).any? {|r| fourFromTowards?(player, r, c, 1, 1)}}
  end

  def diagonalDownWin? (player)
    (0..3).any? {|c| (3..5).any? {|r| fourFromTowards?(player, r, c, -1, 1)}}
  end

  def fourFromTowards?(player, r, c, dx, dy)
    return (0..3).all?{|step| @board[r+step*dx][c+step*dy] == player}
  end
  
  # Check if block is needed
  def horizontalBlock? (player)
    (0..3).any? {|c| (0..5).any? {|r| threeFromTowards?(player, r, c, 0, 1)}}
  end
  
  #----------------------Vertical-----------------------------
  # Check if the given player needs to perform a vertical move
  def doVerticalMove? (player, check)
    r = 0
    begin 
      if @board[r].include?(check)
        insertVertical(player, check, r)
        return true
      end
      #puts("#{r}")
      r += 1
    end until r > 3
    return false
  end
  
  #Find where on the row the insert needs to perform and insert it
  def insertVertical(player, check, r)
    #puts("find row #{r} w/player #{player}")
    c = 0
    begin 
      if @board[r][c] == check
        addDisc(player, c)   
        puts "Vertical #{player} disc added at #{r} , #{c}"
      end
      #puts("#{r} : #{c}")
      c += 1
    end until c > 3
  end
  
  #----------------------Horizontal-----------------------------
  # Check if the given player needs to perform a horizontal move
  def doHorizontalMove? (player, check)
    r = 0
    begin
    #puts"Row : #{r}"
      if !@board[r].nil? && @board[r].count(player) > 2
        insertHorizontal(player, check, r)
        return true
      end
      r += 1
    end until r > 6
    return false
  end
  
  def insertHorizontal(player, check, r)
    puts("find col : R - #{r} w/player #{player}")
    c = 0
    i = 0
    begin 
      if @board[r][c] == player
        i += 1 # We've encountered a check
        if i > 2
          if c < 3
            addDisc(player, c+1)
            puts "Horizontal #{player} disc added at #{r} , #{c+1}"
          else
            addDisc(player, c-3)
            puts "Horizontal #{player} disc added at #{r} , #{c-3}"
          end
        end       
      end
      #puts("#{r} : #{c} -> #{@board[r][c]}")
      c += 1
    end until c > 6
  end
  
  def blockCheck (player, other)
    if doVerticalMove?(player, other)
      puts("#{player} - Perform a Vertical move");
    else
      puts("#{player} - No Vertical Move Needed");
    end
    if doHorizontalMove?(player, other)
      puts("#{player} - Perform a Horizontal block");
    else
      puts("#{player} - No Horizontal Block Needed");
    end
  end
  
  def winCheck (player)
    if hasWon?(player)
      puts("#{player} has won!");
    else
      puts("#{player} has lost!");
    end
  end
end # Board
#------------------------------------------------------------------------------

def robotMove(player, board)   # stub
  other = setRoles(player)
  board.blockCheck(player, other) 
  return rand(7)   
end

def setRoles (player)
  if player == :R
    return :O
  else
    return :R
  end
end

def testResult(testID, move, targets, intent)
  if targets.member?(move)
    puts("testResult: passed test #{testID}")
  else
    puts("testResult: failed test #{testID}: \n moved to #{move}, which wasn't one of #{targets}; \n failed #{intent}")
  end
end


#--------------------------Test Cases----------------------------------------
# test some robot-player behaviors

puts "Board Template!"
puts"0|1|2|3|4|5|6 <- Column"
puts" | | | | | |  5 0 ^"
puts" | | | | | |  4 1 ^"
puts" | | | | | |  3 2 ^"
puts" | | | | | |  2 3 ^"
puts" | | | | | |  1 4 ^"
puts" | | | | | |  0 5 ^Row, rIndex"

puts("\n~~~~~~~~~~~~~~BLOCK 1~~~~~~~~~~~~~~~~~~~~~");
testboard1 = Board.new
testboard1.addDisc(:R,4)
testboard1.addDisc(:O,4)
testboard1.addDisc(:R,5)
testboard1.addDisc(:O,5)
testboard1.addDisc(:R,6)
testboard1.addDisc(:O,6)
testResult(:BLOCK1, robotMove(:R, testboard1),[3], 'robot should block horiz')
testboard1.print
testboard1.winCheck(:R)

#############################
puts("\n~~~~~~~~~~~~~~BLOCK 2~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDiscs(:R, [3, 1, 3, 2, 3]);
#testboard2.addDiscs(:R, [3, 1, 0, 2]);
testResult(:BLOCK2, robotMove(:R, testboard2), [3], 'robot should block vert')
#0|1|2|3|4|5|6
# | | | | | | 5
# | | | | | | 4
# | | | | | | 3
# | | |R| | | 2
# | | |R| | | 1
# |O|O|R| | | 0
testboard2.print
testboard2.winCheck(:R)

puts("\n~~~~~~~~~~~~~~BLOCK 3~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDiscs(:O, [3, 1, 3, 2, 3, 4]);
#0|1|2|3|4|5|6
# | | | | | |  5
# | | | | | |  4
# | | | | | |  3
# | | |O| | |  2
# | | |O| | |  1
# |R|R|O|R| |  0

testResult(:BLOCK3, robotMove(:O, testboard2), [3], 'robot should complete stack')
testboard2.print
testboard2.winCheck(:O)

puts("\n~~~~~~~~~~~~~~BLOCK 4~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDiscs(:R, [3, 1, 4, 5, 2, 1, 6, 0, 3, 4, 5, 3, 2, 2, 6 ]);
#0|1|2|3|4|5|6
# | | | | | |  5
# | | | | | |  4
# | | | | | |  3
# | |O|O| | |  2
# |O|R|R|O|R|R 1
#O|O|R|R|R|O|R 0
testResult(:BLOCK4, robotMove(:O, testboard2), [3], 'robot should complete diag')
testboard2.print
testboard2.winCheck(:O)

puts("\n~~~~~~~~~~~~~~AVOID~~~~~~~~~~~~~~~~~~~~~");
testboard3 = Board.new
testboard3.addDiscs(:O, [1,1,2,2,3,3,4,4])
#0|1|2|3|4|5|6
# | | | | | |  5
# | | | | | |  4
# | | | | | |  3
# | | | | | |  2
# |R|R|R| | |  1
# |O|O|O| | |  0

testResult(:avoid, robotMove(:O, testboard3), [0,6], 'robot should avoid giving win')
testboard3.print
testboard3.winCheck(:O)

puts("\n~~~~~~~~~~~~~~BLOCK 5~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDisc(:O,1) # 1,5
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:R,1)
#testboard2.addDisc(:R,1)
#testboard2.addDisc(:R,1)
#0|1|2|3|4|5|6
# | | | | | |  5 0
# | | | | | |  4 1
# | | | | | |  3 2
# | | | | | |  2 3
# | | | | | |  1 4
# | | | | | |  0 5
testResult(:BLOCK5, robotMove(:R, testboard2), [3], 'robot should complete diag')
testboard2.print
testboard2.winCheck(:R)

puts("\n~~~~~~~~~~~~~~BLOCK 6~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDisc(:O,1)
testboard2.addDisc(:O,1)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:R,1)
#testboard2.addDisc(:R,1)
testResult(:BLOCK5, robotMove(:R, testboard2), [3], 'robot should complete diag')
testboard2.print
testboard2.winCheck(:R)

puts("\n~~~~~~~~~~~~~~BLOCK 7~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDisc(:O,1)
testboard2.addDisc(:O,1)
testboard2.addDisc(:O,1)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:R,1)
testResult(:BLOCK5, robotMove(:R, testboard2), [3], 'robot should complete diag')
testboard2.print
testboard2.winCheck(:R)

puts("\n~~~~~~~~~~~~~~BLOCK 8~~~~~~~~~~~~~~~~~~~~~");
testboard2 = Board.new
testboard2.addDisc(:O,1)
testboard2.addDisc(:O,1)
testboard2.addDisc(:O,1)
testboard2.addDisc(:O,1)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:O,2)
#testboard2.addDisc(:O,2)
testResult(:BLOCK5, robotMove(:R, testboard2), [3], 'robot should complete diag')
testboard2.print
testboard2.winCheck(:R)

puts("\n~~~~~~~~~~~~~~BLOCK 9~~~~~~~~~~~~~~~~~~~~~");
testboard1 = Board.new
testboard1.addDisc(:R,0)
testboard1.addDisc(:O,0)
testboard1.addDisc(:R,1)
testboard1.addDisc(:O,1)
testboard1.addDisc(:R,2)
testboard1.addDisc(:O,2)
testResult(:BLOCK1, robotMove(:R, testboard1),[3], 'robot should block horiz')
testboard1.print
testboard1.winCheck(:R)

puts("\n~~~~~~~~~~~~~~BLOCK 10~~~~~~~~~~~~~~~~~~~~~");
testboard1 = Board.new
testboard1.addDisc(:R,2)
testboard1.addDisc(:O,2)
testboard1.addDisc(:R,3)
testboard1.addDisc(:O,3)
testboard1.addDisc(:R,4)
testboard1.addDisc(:O,4)
testResult(:BLOCK1, robotMove(:R, testboard1),[3], 'robot should block horiz')
testboard1.print
testboard1.winCheck(:R)
##################