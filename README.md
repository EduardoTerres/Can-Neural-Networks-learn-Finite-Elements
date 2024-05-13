This repository is linked and contains the necessary code to reproduce the numerical experiments of the following research paper:

[Can Neural Networks learn Finite Elements?](https://www.researchgate.net/publication/380483586_Can_Neural_Networks_learn_Finite_Elements)

- Script **fem_nn_1.m** trains the neural network by letting all weights and biases $b^{[2]}, W^{[2]}$ and $W^{[3]}$ change freely.
- Script **fem_nn_2.m** trains the neural network by initializing $b^{[2]}$ and $W^{[2]}$ to predetermined values and letting weights $W^{[3]}$ change freely.
- Script **error_plots_table.m** computes the L2 and H1 errors and generates error plots.

The figures in the article have been generated according to the following configuration.

<table>
  <tr>
    <th>Figure X</th>
    <th>Left</th>
    <th>Right</th>
  </tr>
  <tr>
    <td>Figure 1 - fem_nn_1.m</td>
    <td colspan="2">epsilon = 0.1;<br> N = 40;<br> Niter = 1e4;<br> eta = 1e-4;<br> beta = 1e-4;<br> initial_info = false;<br> upwind = false;</td>
  </tr>
  <tr>
    <td>Figure 2 - fem_nn_1.m</td>
    <td colspan="2">epsilon = 0.1;<br> N = 20;<br> Niter = 3 * 1e5;<br> eta = 1e-6;<br> beta = 0;<br> initial_info = true;<br> upwind = false;</td>
  </tr>
  <tr>
    <td>Figure 3 - fem_nn_1.m</td>
    <td>epsilon = 0.1;<br> N = 40;<br> Niter = 5 * 1e5;<br> eta = 1e-7;<br> beta = 0;<br> initial_info = true;<br> upwind = false;</td>
    <td>epsilon = 0.1;<br> N = 100;<br> Niter = 3 * 1e5;<br> eta = 1e-8;<br> beta = 0;<br> initial_info = true;<br> upwind = false;</td>
  </tr>
  <tr>
    <td>Figure 4 - fem_nn_2.m</td>
    <td colspan="2">epsilon = 0.1;<br> N = 20;<br> Niter = 2 * 1e5;<br> eta = 1e-6;<br> beta = 0;<br> upwind = false;</td>
  </tr>
  <tr>
    <td>Figure 5, Table 1, Table 2 - error_plots_table.m</td>
    <td colspan="2">-</td>
  </tr>
  <tr>
    <td>Figure 6 - fem_nn_1.m</td>
    <td colspan="2">epsilon = 0.001;<br> N = 20;<br> Niter = 1e6;<br> eta = 1e-6;<br> beta = 0;<br> initial_info = true;<br> upwind = true;</td>
  </tr>
  <tr>
    <td>Figure 7 - fem_nn_1.m</td>
    <td>epsilon = 0.001;<br> N = 40;<br> Niter = 1e6;<br> eta = 1e-7;<br> beta = 0;<br> initial_info = true;<br> upwind = true;</td>
    <td>epsilon = 0.001;<br> N = 100;<br> Niter = 1e6;<br> eta = 1e-8;<br> beta = 0;<br> initial_info = true;<br> upwind = true;</td>
  </tr>
  <tr>
    <td>Figure 8 - fem_nn_2.m</td>
    <td colspan="2">epsilon = 0.001;<br> N = 40;<br> Niter = 2 * 1e6;<br> eta = 1e-7;<br> beta = 0;<br> upwind = true;</td>
  </tr>
  <tr>
    <td>Figure 9 - fem_nn_2.m</td>
    <td colspan="2">epsilon = 0.001;<br> N = 100;<br> Niter = 4 * 1e5;<br> eta = 1e-9;<br> beta = 0;<br> upwind = true;</td>
  </tr>
</table>

Authors: Julia Novo and Eduardo Terrés
