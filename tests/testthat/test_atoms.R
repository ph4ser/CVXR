TOL <- 1e-5

a <- Variable(name = "a")

x <- Variable(2, name = "x")
y <- Variable(2, name = "y")

A <- Variable(2, 2, name = "A")
B <- Variable(2, 2, name = "B")
C <- Variable(3, 2, name = "C")

test_that("test the norm_inf function", {
  exp <- x + y
  atom <- norm_inf(exp)

  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_true(is_convex(atom))
  expect_true(is_concave(-atom))
  expect_equal(curvature(norm_inf(atom)), CONVEX)
  expect_equal(curvature(norm_inf(-atom)), CONVEX)
})

test_that("test the norm1 function", {
  exp <- x + y
  atom <- norm1(exp)

  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_equal(curvature(norm1(atom)), CONVEX)
  expect_equal(curvature(norm1(-atom)), CONVEX)
})

test_that("test the norm2 function", {
  exp <- x + y
  atom <- norm2(exp)

  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_equal(curvature(norm2(atom)), CONVEX)
  expect_equal(curvature(norm2(-atom)), CONVEX)

  # Test with axis arg
  expr <- p_norm(A, 2, axis = 1)
  expect_equal(size(expr), c(2, 1))
})

test_that("test the power function", {
  for(size in list(c(1, 1), c(3, 1), c(2, 3))) {
    x_pow <- Variable(size[1], size[2])
    y_pow <- Variable(size[1], size[2])
    exp <- x_pow + y_pow

    for(p in c(0, 1, 2, 3, 2.7, 0.67, -1, -2.3, 4/5)) {
      atom <- power(exp, p)
      expect_equal(size(atom), size)

      if(p > 1 || p < 0)
        expect_equal(curvature(atom), CONVEX)
      else if(p == 1)
        expect_equal(curvature(atom), AFFINE)
      else if(p == 0)
        expect_equal(curvature(atom), CONSTANT)
      else
        expect_equal(curvature(atom), CONCAVE)

      if(p != 1)
        expect_equal(sign(atom), POSITIVE)
    }
  }
})

test_that("test the geo_mean function", {
  atom <- geo_mean(x)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)
})

test_that("test the harmonic_mean function", {
  atom <- harmonic_mean(x)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)
})

test_that("test the p_norm function", {
  atom <- p_norm(x, p = 1.5)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = 1)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = 2)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = Inf)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = 0.5)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = 0.7)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = -0.1)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = -1)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)

  atom <- p_norm(x, p = -1.3)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONCAVE)
  expect_equal(sign(atom), POSITIVE)
})

test_that("test the quad_over_lin function", {
  atom <- quad_over_lin(square(x), a)
  expect_equal(curvature(atom), CONVEX)

  atom <- quad_over_lin(-square(x), a)
  expect_equal(curvature(atom), CONVEX)

  atom <- quad_over_lin(sqrt(x), a)
  expect_equal(curvature(atom), UNKNOWN)
  expect_false(is_dcp(atom))

  expect_error(quad_over_lin(x, x))
})

test_that("test the arg count for max_elemwise and min_elemwise", {
  expect_error(max_elemwise(1))
  expect_error(min_elemwise(1))
})

test_that("test the matrix_frac function", {
  atom <- matrix_frac(x, A)
  expect_equal(size(atom), c(1, 1))
  expect_equal(curvature(atom), CONVEX)

  # Test matrix_frac size validation
  expect_error(matrix_frac(x, C))
  expect_error(matrix_frac(Variable(3), A))
})

test_that("test the sign for max_entries", {
  expect_equal(sign(max_entries(1)), POSITIVE)
  expect_equal(sign(max_entries(-2)), NEGATIVE)
  expect_equal(sign(max_entries(Variable())), UNKNOWN)
  expect_equal(sign(max_entries(0)), ZERO)

  # Test with axis argument
  expect_equal(size(max_entries(Variable(2), axis = 1)), c(2, 1))
  expect_equal(size(max_entries(Variable(2), axis = 2)), c(1, 1))
  expect_equal(size(max_entries(Variable(2, 3), axis = 1)), c(2, 1))
  expect_equal(size(max_entries(Variable(2, 3), axis = 2)), c(1, 3))

  # Invalid axis
  expect_error(max_entries(x, axis = 4))
})

test_that("test the sign for min_entries", {
  expect_equal(sign(min_entries(1)), POSITIVE)
  expect_equal(sign(min_entries(-2)), NEGATIVE)
  expect_equal(sign(min_entries(Variable())), UNKNOWN)
  expect_equal(sign(min_entries(0)), ZERO)

  # Test with axis argument
  expect_equal(size(min_entries(Variable(2), axis = 1)), c(2, 1))
  expect_equal(size(min_entries(Variable(2), axis = 2)), c(1, 1))
  expect_equal(size(min_entries(Variable(2, 3), axis = 1)), c(2, 1))
  expect_equal(size(min_entries(Variable(2, 3), axis = 2)), c(1, 3))

  # Invalid axis
  expect_error(min_entries(x, axis = 4))
})

test_that("test sign logic for max_elemwise", {
  expect_equal(sign(max_elemwise(1, 2)), POSITIVE)
  expect_equal(sign(max_elemwise(1, Variable())), POSITIVE)
  expect_equal(sign(max_elemwise(1, -2)), POSITIVE)
  expect_equal(sign(max_elemwise(1, 0)), POSITIVE)

  expect_equal(sign(max_elemwise(Variable(), 0)), POSITIVE)
  expect_equal(sign(max_elemwise(Variable(), Variable())), UNKNOWN)
  expect_equal(sign(max_elemwise(Variable(), -2)), UNKNOWN)

  expect_equal(sign(max_elemwise(0, 0)), ZERO)
  expect_equal(sign(max_elemwise(0, -2)), ZERO)

  expect_equal(sign(max_elemwise(-3, -2)), NEGATIVE)

  # Many args
  expect_equal(sign(max_elemwise(-2, Variable(), 0, -1, Variable(), -1)), POSITIVE)

  # Promotion
  expect_equal(sign(max_elemwise(1, Variable(2))), POSITIVE)
  expect_equal(size(max_elemwise(1, Variable(2))), c(2,1))
})

test_that("test sign logic for min_elemwise", {
  expect_equal(sign(min_elemwise(1, 2)), POSITIVE)
  expect_equal(sign(min_elemwise(1, Variable())), UNKNOWN)
  expect_equal(sign(min_elemwise(1, -2)), NEGATIVE)
  expect_equal(sign(min_elemwise(1, 0)), ZERO)

  expect_equal(sign(min_elemwise(Variable(), 0)), NEGATIVE)
  expect_equal(sign(min_elemwise(Variable(), Variable())), UNKNOWN)
  expect_equal(sign(min_elemwise(Variable(), -2)), NEGATIVE)

  expect_equal(sign(min_elemwise(0, 0)), ZERO)
  expect_equal(sign(min_elemwise(0, -2)), NEGATIVE)

  expect_equal(sign(min_elemwise(-3, -2)), NEGATIVE)

  # Many args
  expect_equal(sign(min_elemwise(-2, Variable(), 0, -1, Variable(), 1)), NEGATIVE)

  # Promotion
  expect_equal(sign(min_elemwise(-1, Variable(2))), NEGATIVE)
  expect_equal(size(min_elemwise(-1, Variable(2))), c(2, 1))
})

test_that("test the sum_entries function", {
  expect_equal(sign(sum_entries(1)), POSITIVE)
  expect_equal(sign(sum_entries(c(1, -1))), UNKNOWN)
  expect_equal(curvature(sum_entries(c(1, -1))), CONSTANT)
  expect_equal(sign(sum_entries(Variable(2))), UNKNOWN)
  expect_equal(size(sum_entries(Variable(2))), c(1,1))
  expect_equal(curvature(sum_entries(Variable(2))), AFFINE)

  # Mixed curvature
  mat <- matrix(c(1,-1), nrow = 1, ncol = 2)
  expect_equal(curvature(sum_entries( mat %*% Square(Variable(2)) )), UNKNOWN)

  # Test with axis argument
  expect_equal(size(sum_entries(Variable(2), axis = 1)), c(2, 1))
  expect_equal(size(sum_entries(Variable(2), axis = 2)), c(1, 1))
  expect_equal(size(sum_entries(Variable(2, 3), axis = 1)), c(2, 1))
  expect_equal(size(sum_entries(Variable(2, 3), axis = 2)), c(1, 3))

  # Invalid axis
  expect_error(sum_entries(x, axis = 4))
})

test_that("test the mul_elemwise function", {
  expect_equal(sign(mul_elemwise(c(1, -1), x)), UNKNOWN)
  expect_equal(curvature(mul_elemwise(c(1, -1), x)), AFFINE)
  expect_equal(size(mul_elemwise(c(1, -1), x)), c(2, 1))
  pos_param <- Parameter(2, sign = "positive")
  neg_param <- Parameter(2, sign = "negative")
  expect_equal(sign(mul_elemwise(pos_param, pos_param)), POSITIVE)
  expect_equal(sign(mul_elemwise(pos_param, neg_param)), NEGATIVE)
  expect_equal(sign(mul_elemwise(neg_param, neg_param)), POSITIVE)

  expect_equal(curvature(mul_elemwise(neg_param, Square(x))), CONCAVE)

  # Test promotion
  expect_equal(size(mul_elemwise(c(1, -1), 1)), c(2, 1))
  expect_equal(size(mul_elemwise(1, C)), size(C))
  expect_error(mul_elemwise(x, c(1, -1)))
})

test_that("test the vstack function", {
  atom <- vstack(x, y, x)
  expect_equal(size(atom), c(6, 1))

  atom <- vstack(A, C, B)
  expect_equal(size(atom), c(7, 2))

  entries <- list()
  for(i in 1:size(x)[1]) {
   for(j in 1:size(x)[2]) {
     entries <- c(entries, x[i, j])
   }
  }
  atom <- do.call(vstack, entries)
  # atom <- vstack(x[1,1], x[2,1])

  expect_error(vstack(C, 1))
})

test_that("test the reshape_expr function", {
  expr <- reshape_expr(A, 4, 1)
  expect_equal(sign(expr), UNKNOWN)
  expect_equal(curvature(expr), AFFINE)
  expect_equal(size(expr), c(4, 1))

  expr <- reshape_expr(expr, 2, 2)
  expect_equal(size(expr), c(2, 2))

  expr <- reshape_expr(square(x), 1, 2)
  expect_equal(sign(expr), POSITIVE)
  expect_equal(curvature(expr), CONVEX)
  expect_equal(size(expr), c(1, 2))

  expect_error(reshape_expr(C, 5, 4))
})

test_that("test the vec function", {
  expr <- vec(C)
  expect_equal(sign(expr), UNKNOWN)
  expect_equal(curvature(expr), AFFINE)
  expect_equal(size(expr), c(6, 1))

  expr <- vec(x)
  expect_equal(size(expr), c(2, 1))

  expr <- vec(square(a))
  expect_equal(sign(expr), POSITIVE)
  expect_equal(curvature(expr), CONVEX)
  expect_equal(size(expr), c(1, 1))
})

test_that("test the diag function", {
  expr <- diag(x)
  expect_equal(sign(expr), UNKNOWN)
  expect_equal(curvature(expr), AFFINE)
  expect_equal(size(expr), c(2,2))

  expr <- diag(A)
  expect_equal(sign(expr), UNKNOWN)
  expect_equal(curvature(expr), AFFINE)
  expect_equal(size(expr), c(2, 1))

  expr <- diag(t(x))
  expect_equal(sign(expr), UNKNOWN)
  expect_equal(curvature(expr), AFFINE)
  expect_equal(size(expr), c(2, 2))

  expect_error(diag(C))
})

test_that("test the matrix_trace function", {
  expr <- matrix_trace(A)
  expect_equal(sign(expr), UNKNOWN)
  expect_equal(curvature(expr), AFFINE)
  expect_equal(size(expr), c(1, 1))

  expect_error(matrix_trace(C))
})

test_that("test the log1p function", {
  expr <- log1p(Constant(1))
  expect_equal(sign(expr), POSITIVE)
  expect_equal(curvature(expr), CONSTANT)
  expect_equal(size(expr), c(1, 1))
  expr <- CVXR::log1p(Constant(-0.5))
  expect_equal(sign(expr), NEGATIVE)
})

test_that("test the upper_tri function", {
  expect_error(upper_tri(C))
})

test_that("test the huber function", {
  huber(x, 1)
  expect_error(huber(x, -1))
  expect_error(huber(x, c(1, 1)))

  # M parameter
  M <- Parameter(sign = "positive")
  # Valid
  huber(x, M)
  M@value <- 1
  expect_equal(value(huber(2, M)), 3, tolerance = TOL)
  # Invalid
  M <- Parameter(sign = "negative")
  expect_error(huber(x, M))
})

test_that("test the sum_largest function", {
  expect_error(sum_largest(x, -1))
  expect_error(lambda_sum_largest(x, 2.4))
  expect_error(lambda_sum_largest(Variable(2, 2), 2.4))
})

test_that("test the sum_smallest function", {
  expect_error(sum_smallest(x, -1))
  expect_error(lambda_sum_smallest(Variable(2, 2), 2.4))
})

test_that("test the bmat function", {
  v_np <- matrix(1, nrow = 3, ncol = 1)
  v_00 <- matrix(c(0,0), nrow = 2, ncol = 1)
  v_12 <- matrix(c(1,2), nrow = 2, ncol = 1)
  expr <- bmat(list(list(v_np, v_np), list(v_00, v_12)))
  expect_equal(size(expr), c(5, 2))
  const <- rbind(cbind(v_np, v_np), cbind(c(0, 0), c(1, 2)))
  expect_equal(value(expr), const)
})

test_that("test the conv function", {
  a <- matrix(1, nrow = 3, ncol = 1)
  b <- Parameter(2, sign = "positive")
  expr <- conv(a, b)
  expect_true(is_positive(expr))
  expect_equal(size(expr), c(4, 1))
  b <- Parameter(2, sign = "negative")
  expr <- conv(a, b)
  expect_true(is_negative(expr))
  expect_error(conv(x, -1))
  expect_error(conv(cbind(c(0, 1), c(0, 1)), x))
})

test_that("test the kronecker function", {
  a <- matrix(1, nrow = 3, ncol = 2)
  b <- Parameter(2, sign = "positive")
  expr <- kronecker(a, b)
  expect_true(is_positive(expr))
  expect_equal(size(expr), c(6, 2))
  b <- Parameter(2, sign = "negative")
  expr <- kronecker(a, b)
  expect_true(is_negative(expr))
  expect_error(kronecker(x, -1))
})

test_that("test DCP properties of partial optimize", {
  # Evaluate the 1-norm in the usual way (i.e., in epigraph form)
  dims <- 3
  x <- Variable(dims)
  t <- Variable(dims)
  xval <- matrix(rep(-5, dims), nrow = dims, ncol = 1)
  p2 <- Problem(Minimize(sum_entries(t)), list(-t <= x, x <= t))
  # g <- partial_optimize(p2, list(t), list(x))
  # expect_equal(curvature(g), CONVEX)

  p2 <- Problem(Maximize(sum_entries(t)), list(-t <= x, x <= t))
  # g <- partial_optimize(p2, list(t), list(x))
  # expect_equal(curvature(g), CONCAVE)

  p2 <- Problem(Maximize(square(t[1])), list(-t <= x, x <= t))
  # g <- partial_optimize(p2, list(t), list(x))
  # expect_false(is_convex(g))
  # expect_false(is_concave(g))
})

test_that("test the partial_optimize eval 1-norm", {
  # Evaluate the 1-norm in the usual way (i.e., in epigraph form)
  dims <- 3
  x <- Variable(dims)
  t <- Variable(dims)
  xval <- matrix(rep(-5, dims), nrow = dims, ncol = 1)
  p1 <- Problem(Minimize(sum_entries(t)), list(-t <= xval, xval <= t))
  result1 <- solve(p1)

  # Minimize the 1-norm via partial_optimize
  p2 <- Problem(Minimize(sum_entries(t)), list(-t <= x, x <= t))
  # g <- partial_optimize(p2, list(t), list(x))
  # p3 <- Problem(Minimize(g), list(x == xval))
  # result3 <- solve(p3)
  # expect_equal(result1$value, -result3$value)

  # Try leaving out args

  # Minimize the 1-norm via partial_optimize
  p2 <- Problem(Minimize(sum_entries(t)), list(-t <= x, x <= t))
  # g <- partial_optimize(p2, opt_vars = list(t))
  # p3 <- Problem(Minimize(g), list(x == xval))
  # result3 <- solve(p3)
  # expect_equal(result1$value, result3$value)

  # Minimize the 1-norm via partial_optimize
  # g <- partial_optimize(p2, dont_opt_vars = list(x))
  # p3 <- Problem(Minimize(g), list(x == xval))
  # result3 <- solve(p3)
  # expect_equal(result1$value, result3$value)

  # expect_error(partial_optimize(p2))
  # expect_error(partial_optimize(p2, list(), list(x)))
})

test_that("test partial_optimize min 1-norm", {
  # Minimize the 1-norm in the usual way
  dims <- 3
  x <- Variable(dims)
  t <- Variable(dims)
  p1 <- Problem(Minimize(sum_entries(t)), list(-t <= x, x <= t))

  # Minimize the 1-norm via partial_optimize
  # g <- partial_optimize(p1, list(t), list(x))
  # p2 <- Problem(Minimize(g))
  # result2 <- solve(p2)

  result1 <- solve(p1)
  # expect_equal(result1$value, result2$value)
})

test_that("test partial_optimize simple problem", {
  x <- Variable(1)
  y <- Variable(1)

  # Solve the (simple) two-stage problem by "combining" the two stages (i.e., by solving a single linear program)
  p1 <- Problem(Minimize(x+y), list(x+y >= 3, y >= 4, x >= 5))
  result1 <- solve(p1)

  # Solve the two-stage problem via partial_optimize
  p2 <- Problem(Minimize(y), list(x+y >= 3, y >= 4))
  # g <- partial_optimize(p2, list(y), list(x))
  # p3 <- Problem(Minimize(x+g), list(x >= 5))
  # result3 <- solve(p3)
  # expect_equal(result1$value, result3$value)
})

test_that("test partial_optimize special var", {
  x <- Bool(1)
  y <- Int(1)

  # Solve the (simple) two-stage problem by "combining" the two stages (i.e., by solving a single linear program)
  p1 <- Problem(Minimize(x+y), list(x+y >= 3, y >= 4, x >= 5))
  # result1 <- solve(p1)

  # Solve the two-stage problem via partial_optimize
  p2 <- Problem(Minimize(y), list(x+y >= 3, y >= 4))
  # g <- partial_optimize(p2, list(y), list(x))
  # p3 <- Problem(Minimize(x+g), list(x >= 5))
  # result3 <- solve(p3)
  # expect_equal(result1$value, result3$value)
})

test_that("test partial_optimize special constr", {
  x <- Variable(1)
  y <- Variable(1)

  # Solve the (simple) two-stage problem by "combining" the two stages (i.e., by solving a single linear program)
  p1 <- Problem(Minimize(x+exp(y)), list(x+y >= 3, y >= 4, x >= 5))
  result1 <- solve(p1)

  # Solve the two-stage problem via partial_optimize
  p2 <- Problem(Minimize(exp(y)), list(x+y >= 3, y >= 4))
  # g <- partial_optimize(p2, list(y), list(x))
  # p3 <- Problem(Minimize(x+g), list(x >= 5))
  # result3 <- solve(p3)
  # expect_equal(result1$value, result3$value)
})

test_that("test partial_optimize with parameters", {
  x <- Variable(1)
  y <- Variable(1)
  gamma <- Parameter()

  # Solve the (simple) two-stage problem by "combining" the two stages (i.e., by solving a single linear program)
  p1 <- Problem(Minimize(x+y), list(x+y >= gamma, y >= 4, x >= 5))
  gamma@value <- 3
  # result1 <- solve(p1)

  # Solve the two-stage problem via partial_optimize
  p2 <- Problem(Minimize(y), list(x+y >= gamma, y >= 4))
  # g <- partial_optimize(p2, list(y), list(x))
  # p3 <- Problem(Minimize(x+g), list(x >= 5))
  # result3 <- solve(p3)
  # expect_equal(result1$value, result3$value)
})

test_that("test partial_optimize numeric function", {
  x <- Variable(1)
  y <- Variable(1)
  xval <- 4

  # Solve the (simple) two-stage problem by "combining" the two stages (i.e., by solving a single linear program)
  p1 <- Problem(Minimize(y), list(xval+y >= 3))
  result1 <- solve(p1)

  # Solve the two-stage problem via partial_optimize
  constr <- list(y >= -100)
  p2 <- Problem(Minimize(y), c(x+y >= 3, constr))
  # g <- partial_optimize(p2, list(y), list(x))
  # x@value <- xval
  # y@value <- 42
  # const[1]@dual_variable@value <- 42
  # result <- g@value
  # expect_equal(result, result1$value)
  # expect_equal(y@value, 42)
  # expect_equal(constr[1]@dual_value, 42)

  # No variables optimized over
  p2 <- Problem(Minimize(y), list(x+y >= 3))
  # g <- partial_optimize(p2, list(), list(x,y))
  # x@value <- xval
  # y@value <- 42
  # p2@constraints[1]@dual_variable@value <- 42
  # result <- g@value
  # expect_equal(result, y@value)
  # expect_equal(y@value, 42)
  # expect_equal(p2@constraints[1]@dual_value, 42)
})

test_that("test partial_optimize stacked", {
  # Minimize the 1-norm in the usual way
  dims <- 3
  x <- Variable(dims)
  t <- Variable(dims)
  p1 <- Problem(Minimize(sum_entries(t)), list(-t <= x, x <= t))

  # Minimize the 1-norm via partial_optimize
  # g <- partial_optimize(p1, list(t), list(x))
  # g2 <- partial_optimize(Problem(Minimize(g)), list(x))
  # p2 <- Problem(Minimize(g2))
  # result2 <- solve(p2)

  result1 <- solve(p1)
  # expect_equal(result1$value, result2$value)
})

test_that("test the NonNegative Variable class", {
  x <- NonNegative()
  p <- Problem(Minimize(5+x), list(x >= 3))
  result <- solve(p)
  # expect_equal(result$value, 8, tolerance = TOL)
  # expect_equal(result$getValue(x), 3, tolerance = TOL)
})

test_that("test whether changing an array constant breaks DCP", {
  c <- matrix(c(1, 2), nrow = 2, ncol = 1)
  x@primal_value <- c(1, 1)
  expr <- t(c) %*% square(x)
  expect_equal(value(expr), 3, tolerance = TOL)
  expect_true(is_dcp(expr))

  c[1] <- -1
  expect_equal(value(expr), 3, tolerance = TOL)
  expect_true(is_dcp(expr))
})
