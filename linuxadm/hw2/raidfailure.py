import math

def calculatekofn(k, n, p):
    return math.factorial(n) / (math.factorial(n - k) * math.factorial(k)) * math.pow(p, k) * math.pow (1-p, n-k)

def calculatefailurerate(k_min, n, p):
    result = 0.0
    for i in range(k_min, n+1):
        result += calculatekofn(i, n, p)
    return result

print(calculatefailurerate(3, 8, 0.01) * 100)