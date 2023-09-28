#include <iostream>
#include <cmath>

constexpr int N = 5;
float matrix[N][N + 1] = {
    {1,4,5,6,1,5},{-3,4,6,5,1,-7},{6,-4,5,-8,6,4},{1,2,-3,5,-7,9},{6,-6,2,3,4,5}

};

float X[N];

void Display() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N + 1; j++) {
            unsigned int unsig_value;
            memcpy(&unsig_value, &matrix[i][j], sizeof(unsig_value));
            std::cout << std::hex << unsig_value << "\t";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

int back_substitution() {
    for (int i = N - 1; i >= 0; i--) {
        X[i] = matrix[i][N];
        for (int j = i + 1; j < N; j++)
            X[i] -= matrix[i][j] * X[j];

        if (X[i] == 0 && matrix[i][i] == 0) {
            std::cout << "Infinitely many solutions exist" << std::endl;
            return 1;
        }
        if (X[i] != 0 && matrix[i][i] == 0) {
            std::cout << "No solution exists" << std::endl;
            return 1;
        }
        X[i] /= matrix[i][i];
    }
    return 0;
}

void swap(int i, int k) {
    float temp;
    for (int j = 0; j < N + 1; j++) {
        temp = matrix[i][j];
        matrix[i][j] = matrix[k][j];
        matrix[k][j] = temp;
    }
}

void partial_pivoting(int i) {
    for (int k = i + 1; k < N; k++) {
        if (fabs(matrix[i][i]) < fabs(matrix[k][i]))
            swap(i, k);
    }
}

void gauss_elimination() {
    float ratio;
    for (int i = 0; i <= N; i++) {
        Display();
        partial_pivoting(i);
        Display();
        for (int k = i + 1; k < N; k++) {
            if (matrix[i][i] == 0)
                break;
            ratio = matrix[k][i] / matrix[i][i];
            for (int j = 0; j < N + 1; j++)
                matrix[k][j] -= ratio * matrix[i][j];
        }
    }
}

int main() {
    gauss_elimination();
    std::cout << "\n\n";
    std::cout << "Upper Triangular matrix after Gauss Elimination" << std::endl;
    std::cout << "\n\n";
    Display();
    int res = back_substitution();
    if (res != 1) {
        std::cout << "\n\n";
        std::cout << "Solution to linear set of equations X=x1,x2,x3,x4,x5" << std::endl;
        std::cout << "\n\n";
        for (int k = 0; k < N; k++) {
            unsigned int unsig_value;
            memcpy(&unsig_value, &X[k], sizeof(unsig_value));
            std::cout << "x[" << k << "] = " << std::hex << unsig_value << std::endl;
        }
    }
    return 0;
}
