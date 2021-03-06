module Part1 where

import Control.Monad
import Data.Char

data StudentInfo = StudentInfo { name :: String,
                                 korScore :: Int,
                                 engScore :: Int,
                                 matScore :: Int
                               } deriving (Show)

type StudentInfos = [StudentInfo]

main :: IO ()
main = start []

start :: StudentInfos -> IO ()
start studentInfos = do
  printMenu
  input <- getLine
  s <- play (read input) studentInfos
  Control.Monad.unless (read input == 3) $ start s

printMenu :: IO ()
printMenu = do
    putStrLn "\n- Menu Select -"
    putStrLn "   1. Input Student's grade"
    putStrLn "   2. Print Student's grade"
    putStrLn "   3. Exit\n"
    putStr "Select : "
    return ()

play :: Int -> StudentInfos -> IO StudentInfos
play n studentInfos
    | n == 1 = readStudentInformation studentInfos
    | n == 2 = do
        printScoreTable studentInfos
        return studentInfos
    | n == 3 = return studentInfos
    | otherwise = do
        putStrLn "\nInvalid number! Try again.\n"
        return studentInfos

readStudentInformation :: StudentInfos -> IO StudentInfos
readStudentInformation studentInfos = do
  putStr "> Name : "
  name <- getLine
  putStr "> Korean : "
  koreanScore <- getLine
  putStr "> English : "
  englishScore <- getLine
  putStr "> Math : "
  mathScore <- getLine
  let updated = StudentInfo name (read koreanScore) (read englishScore) (read mathScore):studentInfos
  putStr "> Do you continue to input (Y/N)? "
  answer <- getLine
  if map toUpper answer == "Y" then readStudentInformation updated else return updated

printScoreTable :: StudentInfos -> IO ()
printScoreTable studentInfos = do
 putStrLn "Name\t\tKor\tEng\tMath\tSum\tAvg\tRank"
 putStrLn "========================================================="
 mapM_ (putStrLn . (`makeInfo` rankResult)) studentInfos
 putStrLn "========================================================="
 putStrLn $ "Sum\t\t" ++ show (sumOfKorScore studentInfos) ++ "\t" ++ show (sumOfEngScore studentInfos) ++ "\t" ++ show (sumOfMatScore studentInfos) ++ "\t" ++ show (sumOfTotalScore studentInfos)
 putStrLn $ "Avg\t\t" ++ show (avgOfKorScore studentInfos) ++ "\t" ++ show (avgOfEngScore studentInfos) ++ "\t" ++ show (avgOfMatScore studentInfos) ++ "\t" ++ show (avgOfTotalScore studentInfos)
 where rankResult = (qsort . sums) studentInfos

makeInfo :: StudentInfo -> [Int] -> String
makeInfo info rankResult = name info ++ "\t\t" ++ show (korScore info) ++ "\t" ++ show (engScore info) ++ "\t" ++ show (matScore info) ++ "\t" ++
                           show totalSum ++ "\t" ++ show (average info) ++ "\t" ++ show (rank rankResult totalSum)
                           where totalSum = sum' info

-- studentInfos :: StudentInfos
-- studentInfos = [ StudentInfo { name = "John", korScore = 96, engScore = 92, matScore = 98 },
--                  StudentInfo { name = "Chris", korScore = 88, engScore = 90, matScore = 68 },
--                  StudentInfo { name = "James", korScore = 98, engScore = 80, matScore = 75 },
--                  StudentInfo { name = "Tom", korScore = 64, engScore = 70, matScore = 72 },
--                  StudentInfo { name = "Jane", korScore = 80, engScore = 88, matScore = 94 }
--                ]

sum' :: StudentInfo -> Int
sum' (StudentInfo _ korScore engScore matScore) = korScore + engScore + matScore

sums :: StudentInfos -> [Int]
sums = map sum'

average :: StudentInfo -> Float
average info = fromIntegral (sum' info) / 3.0

rank :: [Int] -> Int -> Int
rank xs index = 1 + findIndex xs index

qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort [a | a <- xs, a > x] ++ x : qsort [a | a <- xs, x >= a]

findIndex :: [Int] -> Int -> Int
findIndex (x:xs) index
 | x == index = 0
 | otherwise = 1+ findIndex xs index

sumOfKorScore :: StudentInfos -> Int
sumOfKorScore = foldr (\(StudentInfo _ korScore _ _) acc -> korScore + acc) 0

sumOfEngScore :: StudentInfos -> Int
sumOfEngScore = foldr (\(StudentInfo _ _ engScore _) acc -> engScore + acc) 0

sumOfMatScore :: StudentInfos -> Int
sumOfMatScore = foldr (\(StudentInfo _ _ _ matScore) acc -> matScore + acc) 0

sumOfTotalScore :: StudentInfos -> Int
sumOfTotalScore = foldr (\info acc -> sum' info + acc) 0

avgOfKorScore :: StudentInfos -> Float
avgOfKorScore info = fromIntegral (sumOfKorScore info) / fromIntegral (length info)

avgOfEngScore :: StudentInfos -> Float
avgOfEngScore info = fromIntegral (sumOfEngScore info) / fromIntegral (length info)

avgOfMatScore :: StudentInfos -> Float
avgOfMatScore info = fromIntegral (sumOfMatScore info) / fromIntegral (length info)

avgOfTotalScore :: StudentInfos -> Float
avgOfTotalScore info = fromIntegral (sumOfTotalScore info) / fromIntegral (length info * 3)
