## R functions that enable user to;
#   1. Save a Matrix
#   2. Generate the Matrix's Inverse
#   3. Cache the Inverse of the Matrix and only calculate when the underlying matrix changes

## Function to create a special CacheMatrix data structure
makeCacheMatrix <- function(x = matrix()) {
        
        # Set up working variables
        need_to_solve_flag = TRUE            # Flag indicating if a solve calculation is required 
                                             #    (i.e. matrix has changed since last calculation)
                                             
        store_solved_matrix = NULL           # A variable to store the solved matrix in between calculations
        
        # Function to return the underlying matrix
        get_matrix <- function() {
                x
        }
        
        # Function to set the underlying matrix to a new matrix
        set_matrix <- function(y) {
                # A new matrix has been saved, set the need_to_solve_flag to TRUE
                #   A solve calculation will be needed when next requested
                need_to_solve_flag <<- TRUE
                
                # Update the underlying matrix to the new matrix passed to the function
                x <<- y
        }
        
        # Solve the matrix - execute solve calculation only when needed
        solve_matrix <- function() {
                # Determine if a solve calculation is required
                if (need_to_solve_flag) 
                {
                        # Solve calculation is required
                        store_solved_matrix <<- solve(x)
                        # Set need_to_solve_flag to FALSE, don't need to calculate until the underlying matrix changes again
                        need_to_solve_flag <<- FALSE
                } 
                        
                # Return the solution - the cached version (default) or newly caculated version (if needed)
                store_solved_matrix
        }
        
        # Construct the data structure with functions to:
        #   - "get"   return the underlying matrix
        #   - "set"   store a new value for the matrix
        #   - "solve" return the inverse matrix
        list(get = get_matrix, set = set_matrix, solveMatrix = solve_matrix)
}

## Function that returns the inverse of a "special" matrix
cacheSolve <- function(x, ...) {
        # Call the special matrix's "solveMatrix" function to:
        #   1. Check if a new solve calculation is required
        #   2. If required (i.e. the underlying matrix has changed since the last calculation) then trigger the calculation
        #   3. If not required return the cached version
        x$solveMatrix()
}




