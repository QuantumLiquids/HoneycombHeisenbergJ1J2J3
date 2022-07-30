/**
 * 2 processes parallel
 */
#include "gqmps2/gqmps2.h"
#include "gqten/gqten.h"
#include <ctime>
#include "DefSpinOne.h"
#include "operators.h"
#include "params_case.h"
#include "myutil.h"
#include "my_measure.h"


using namespace gqmps2;
using namespace gqten;
using namespace std;

int main(int argc, char *argv[]) {
  namespace mpi = boost::mpi;
  mpi::environment env;
  mpi::communicator world;

  CaseParams params(argv[1]);
  size_t Lx = params.Lx;
  size_t N= 2 * Lx * params.Ly;

  clock_t startTime,endTime;
  startTime = clock();

  gqten::hp_numeric::SetTensorTransposeNumThreads(params.Threads);
  gqten::hp_numeric::SetTensorManipulationThreads(params.Threads);


  using namespace spin_one_model;
  OperatorInitial();
  const SiteVec<TenElemT, U1QN> sites=SiteVec<TenElemT, U1QN>(N, pb_out);


  using FiniteMPST = gqmps2::FiniteMPS<TenElemT, U1QN>;
  FiniteMPST mps(sites);
//  mps.Load();
//  cout << "mps loaded" <<endl;
//  cout << "bond dimension of middle mps = " ;
//  cout << mps[N/2].GetShape()[0] <<endl;

  Timer one_site_timer("measure  one site operators");
  if(world.rank() == 0){
    MeasureOneSiteOp(mps, kMpsPath, sz, "sz");
  } else{
    MeasureOneSiteOp(mps, kMpsPath, sz_square, "sz_square");
  }

  cout << "measured one point function.<====" <<endl;
  one_site_timer.PrintElapsed();


  endTime = clock();
  cout << "CPU Time : " <<(double)(endTime - startTime) / CLOCKS_PER_SEC << "s" << endl;
  return 0;
}