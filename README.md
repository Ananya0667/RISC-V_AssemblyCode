# RISC-V_AssemblyCode
RISC-V Assembly code for gaussian elimination
Design Considerations
• The requirement for solving the set of linear equations is that we have 5 equations
with 5 unknowns such that AX=B where A is 5*5 matrix and X is a 5*1 matrix. Our
input is A and B and we have to solve for X.
• We have to solve the equation of below type:
a11x1 + a12x2 + a13x3 + a14x4 + a15x5 = b1
a21x1 + a22x2 + a23x3 + a24x4 + a25x5 = b2
a31x1 + a32x2 + a33x3 + a34x4 + a35x5 = b3
a41x1 + a42x2 + a43x3 + a44x4 + a45x5 = b4
a51x1 + a52x2 + a53x3 + a54x4 + a55x5 = b5
Solving for X = x1, x2, x3, x4, x5 that satisfy this system of equations
• method reduces the system to an upper triangular matrix from which the
unknowns are derived by the use of backward substitution method.
• Assuming a1 ≠ 0, x is eliminated from the second equation by subtracting (a2/
a1) times the first equation from the second equation and so on,eliminates x from
third equation by subtracting (a3/a1) times the first equation from the third
equation.
• The elimination procedure is continued until only one unknown remains in
the last equation. After its value is determined, the procedure is stopped. Now,
Gauss Elimination in C uses back substitution to get the values of X.

Exponent (E) uses 8 bits and includes a bias of 127, which means the actual exponent
value is calculated as E - 127. Mantissa (M) uses 23 bits for representing the
fractional part of the number, normalized to have a leading 1 bit.
• The numerical algorithm used for solving linear equations with floating-point
numbers is Gaussian elimination, also known as row reduction computational
procedure, which converts the augmented matrix i.e., the coefficients of matrix A
and B together into row reduced echelon form.
• The algorithm is quite efficient but incurs different cases when matrix is singular
during computation. The cases are Unique solution (non -singular matrix), No
solution and Infinite solution. We must consider all three solutions in our assembly
code.
• Error is reported based on RISCV assembly output of matrix X and C++ program for
the equation AX=B.
• We have optimized the assembly code for efficiency by taking into account pivoting.
Partial pivoting is a technique used to re-order the rows of a matrix during Gaussian
elimination to improve numerical stability and reduce round-off errors. It ensures
that the largest absolute values in the current column are moved to the diagonal
position (matrix[i][i]), which can help prevent division by very small numbers and
reduce the accumulation of errors in numerical computations
• To achieve a balance between precision and performance, we have used floating
point registers for storing input data, intermediate results, and the final solution. We
have assumed that the IEEE 754 floating-point format provides sufficient precision
and accuracy for solving linear equations, given the specified input data.
• The output matrix X =x1,x2,x3,x4,x5 is represented in hexadecimal format in both
assembly code and C++ program.
• The assembly code is tested on comprehensive test cases to validate the correctness
and accuracy of the algorithm implemented. The test cases include boundary cases,
extreme values, and randomized inputs.
• You may assume that the chosen numerical algorithm i.e., gaussian elimination for
solving linear equations behaves correctly and converges to a solution for the
majority of input cases.
• The assembly code depends on the adherence of the hardware to the IEEE 754
standard for floating-point representation.
• RISC-V assembly, requires an assembler and a simulator to develop and test your
code. We have used RISC-V Venus Simulator and gnu Assembler. We are using
Visual Studio Code which is Integrated Development Environment (IDE) that
supports RISC-V assembly, with appropriate extensions.
• RISC-V development is platform-independent, versatile and can run on various
operating systems.
• Risc V has ‘32’- 32 bit registers.
• RISC-V is called “32-bit architecture” because it operates on 32- bit data.S0-s11 are
used to store variables.T0-t6 to hold temporary results. A0-A7 are arguments i.e they
are values passed to a function and values returned from a function call.
• RISC V is byte addressable.
Architectural Strategies
• The assembly code is divided into functions so that we don’t have to step over and
only call the main function once to get the output on the output terminal. The code
is divided into components, each responsible for specific task. This simplifies testing
and enhances maintainability.
• We have floating point data representation for representing matrices, vectors, and
temporary variables. Efficient data representation minimizes memory usage and
maximizes computational efficiency. We have used minimum number of registers
only limited to a0-a4, t0-t5, s0-s1 and loop counters and temp variables initialized
globally for efficient usage of registers.
• Balancing precision with computational efficiency ensures accurate results without
unnecessary overhead. We are using single precision for solving linear equations.
• We have an efficiently managed memory such that we are reusing registers to the
optimize memory usage. Proper memory management reduces the risk of memory
leaks and enhances overall performance.
• Applied optimization techniques specific to the RISC-V architecture, such as
instruction reordering and loop unrolling which enhances code execution speed and
efficiency.
• The assembly code includes comprehensive comments explaining the instructions
for easy understanding and flow of program


The functionality of the system is divided into different modules:
• Input: Augmented matrix[A|B] with 5 rows and 6 columns. The coefficients are in
floating point format.
• Main:We call the function gaussian elimination. Main() function is created to avoid
step over the entire program and we get out output matrix X in few step overs.
• Gauss Elimination with partial pivoting: reduces the matrix to upper triangular form.
Partial pivoting ensures largest absolute value in each column is in the diagonal
position. We perform partial pivoting for each column and for each row below the
current row, we check if the diagonal element is zero. We swap the rows, ensuring
that the largest absolute value is moved to the diagonal position.
• Back substitution: We start with last row and move upwards having x5 equal to a
constant. We subtract the known values of X (calculated in previous iterations) from
the current equation to find the value of X[i]. Here, occurs two cases of no solution
and infinite solution when matrix is Singular.
• Print matrix X: print the value of the binary representation of matrix[i][j] in
hexadecimal format
