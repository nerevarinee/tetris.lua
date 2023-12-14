-- Tetris in Lua

-- Define the game board
local boardWidth = 10
local boardHeight = 20
local board = {}

-- Define the Tetris pieces
local pieces = {
    { {1, 1, 1, 1} }, -- I-piece
    { {1, 1, 1}, {1} }, -- L-piece
    { {1, 1, 1}, {0, 1} }, -- J-piece
    { {1, 1}, {1, 1} }, -- O-piece
    { {1, 1, 1}, {0, 0, 1} }, -- T-piece
}

-- Current piece and its position
local currentPiece = {}
local currentX, currentY = 1, 1

-- Function to initialize the game board
function initBoard()
    for i = 1, boardHeight do
        board[i] = {}
        for j = 1, boardWidth do
            board[i][j] = 0
        end
    end
end

-- Function to print the game board
function printBoard()
    for i = 1, boardHeight do
        for j = 1, boardWidth do
            io.write(board[i][j] == 0 and "." or "#")
        end
        print()
    end
end

-- Function to rotate a piece
function rotatePiece(piece)
    local newPiece = {}
    local pieceSize = #piece
    for i = 1, pieceSize do
        newPiece[i] = {}
        for j = 1, pieceSize do
            newPiece[i][j] = piece[pieceSize - j + 1][i]
        end
    end
    return newPiece
end

-- Function to check if a piece can be placed at the current position
function canPlace(piece, x, y)
    for i = 1, #piece do
        for j = 1, #piece[i] do
            if piece[i][j] == 1 then
                local boardX, boardY = x + j - 1, y + i - 1
                if boardX < 1 or boardX > boardWidth or boardY < 1 or boardY > boardHeight or board[boardY][boardX] == 1 then
                    return false
                end
            end
        end
    end
    return true
end

-- Function to place a piece on the board
function placePiece(piece, x, y)
    for i = 1, #piece do
        for j = 1, #piece[i] do
            if piece[i][j] == 1 then
                board[y + i - 1][x + j - 1] = 1
            end
        end
    end
end

-- Function to clear completed lines
function clearLines()
    for i = boardHeight, 1, -1 do
        local lineFull = true
        for j = 1, boardWidth do
            if board[i][j] == 0 then
                lineFull = false
                break
            end
        end

        if lineFull then
            table.remove(board, i)
            table.insert(board, 1, {})
            for j = 1, boardWidth do
                board[1][j] = 0
            end
        end
    end
end

-- Function to move the current piece down
function moveDown()
    if canPlace(currentPiece, currentX, currentY + 1) then
        currentY = currentY + 1
    else
        placePiece(currentPiece, currentX, currentY)
        clearLines()
        newPiece()
    end
end

-- Function to move the current piece left
function moveLeft()
    if canPlace(currentPiece, currentX - 1, currentY) then
        currentX = currentX - 1
    end
end

-- Function to move the current piece right
function moveRight()
    if canPlace(currentPiece, currentX + 1, currentY) then
        currentX = currentX + 1
    end
end

-- Function to start a new piece
function newPiece()
    currentPiece = pieces[math.random(#pieces)]
    currentX = math.floor(boardWidth / 2) - math.floor(#currentPiece[1] / 2)
    currentY = 1
    if not canPlace(currentPiece, currentX, currentY) then
        print("Game Over")
        os.exit()
    end
end

-- Main game loop
initBoard()
newPiece()

while true do
    printBoard()
    print("Controls: A (left), D (right), Q (quit)")

    local input = io.read()

    if input == "A" or input == "a" then
        moveLeft()
    elseif input == "D" or input == "d" then
        moveRight()
    elseif input == "Q" or input == "q" then
        print("Thanks for playing!")
        os.exit()
    else
        moveDown()
    end
end
