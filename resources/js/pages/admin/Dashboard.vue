<template>
  <div class="content">
    <div class="container">
    <div class="row" v-if="$can('dashboard-keterlambatan')">
      <div class="container-fluid card">
					<div class="col col-md-12">
						<div class="row">
							<div class="col col-md-5">
								<h4>Statistik hari ini</h4>
										Total Penerimaan Barang<span class="pull-right strong">- 15%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="15"aria-valuemin="0" aria-valuemax="100" style="width:15%">15%</div>
										</div>
									
										Penerimaan Barang dalam proses<span class="pull-right strong">+ 30%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="30"aria-valuemin="0" aria-valuemax="100" style="width:30%">30%</div>
										</div>
									
										Total Posting<span class="pull-right strong">+ 8%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="8"aria-valuemin="0" aria-valuemax="100" style="width:8%">8%</div>
										</div>
							</div>
							<div class="col col-md-5">
								<h4>Statistik Bulan ini:</h4>
										Total Penerimaan Barang<span class="pull-right strong">+ 45%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="45"aria-valuemin="0" aria-valuemax="100" style="width:45%">45%</div>
										</div>
									
										Penerimaan Barang dalam proses<span class="pull-right strong">+ 57%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="57"aria-valuemin="0" aria-valuemax="100" style="width:57%">57%</div>
										</div>
									
										Total Posting<span class="pull-right strong">+ 25%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="25"aria-valuemin="0" aria-valuemax="100" style="width:25%">25%</div>
										</div>
							</div>
						</div>
					</div>
      </div>
      <div class="container-fluid card">
					<div class="col col-md-12">
						<div class="row">
							<div class="col col-md-5">
								<!-- <h4>Statistik hari ini</h4> -->
										Total Pengeluaran Barang<span class="pull-right strong">- 15%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="15"aria-valuemin="0" aria-valuemax="100" style="width:15%">15%</div>
										</div>
									
										Pengeluaran Barang dalam proses<span class="pull-right strong">+ 30%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="30"aria-valuemin="0" aria-valuemax="100" style="width:30%">30%</div>
										</div>
									
										Total Posting<span class="pull-right strong">+ 8%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="8"aria-valuemin="0" aria-valuemax="100" style="width:8%">8%</div>
										</div>
							</div>
							<div class="col col-md-5">
								<!-- <h4>Statistik Bulan ini:</h4> -->
										Total Pengeluaran Barang<span class="pull-right strong">+ 45%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="45"aria-valuemin="0" aria-valuemax="100" style="width:45%">45%</div>
										</div>
									
										Pengeluaran Barang dalam proses<span class="pull-right strong">+ 57%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="57"aria-valuemin="0" aria-valuemax="100" style="width:57%">57%</div>
										</div>
									
										Total Posting<span class="pull-right strong">+ 25%</span>
										 <div class="progress">
											<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="25"aria-valuemin="0" aria-valuemax="100" style="width:25%">25%</div>
										</div>
							</div>
						</div>
					</div>
      </div>
    </div>

  </div>
  </div>
</template>
<script>
  import axios from 'axios'
  import LineChart from '../../components/Chart'
  export default {
    data() {
      return {
        chart: null,
        city: '',
        kantor: [],
        jumlah_karyawan: [],
        jumlah_jenis: [],
        kehadiran: [],
        terlambat: [],
        value:[],
        label:[],
        karyawan:[],
        tepat:[],
        telat:[],
        karyawanSby:[],
        tepatSby:[],
        telatSby:[],
        loading: false,
        errored: false
      }},
    created() {
        this.getProjects();
    },
    methods: {
    getProjects: function() {
      
      // this.loading = true;

      // if (this.chart != null) {
      //   this.chart.destroy();
      // }
      axios
        .get('telat').then(response => {
          
          //jumlah karyawan
          this.kantor = response.data.data.map(data => {
            return (data.kantor);
          });

          this.jumlah_karyawan = response.data.data.map(data => {
            return data.jumlah;
          });

          // // telat per divisi
          this.jumlah_jenis = response.data.data3.map(data => {
            return (data.jml);
          });

          var nli = [];
          $.each(response.data.data4, function(k, v){
            nli[k] = v;
          });

          this.kehadiran = nli;

          var terlambat7 = [];
          $.each(response.data.data5, function(k, v){
            terlambat7[k] = v;
            
          });

          var terlambat7hr = [];
          var label = [];
          $.each(response.data.data6, function(k, v){
            terlambat7hr[k] = v;
            label.push(k);

          });
            this.label = label;
          // this.terlambat = terlambat7;
          var karyawan = [];
          var tepat = [];
          var telat = [];
          var karyawanSby = [];
          var tepatSby = [];
          var telatSby = [];
          $.each(label, function(k,v){
            karyawan.push(terlambat7hr[v]['bandung']['jml_karyawan']);
            tepat.push(terlambat7hr[v]['bandung']['tepat']);
            telat.push(terlambat7hr[v]['bandung']['telat']);
            
            karyawanSby.push(terlambat7hr[v]['surabaya']['jml_karyawan']);
            tepatSby.push(terlambat7hr[v]['surabaya']['tepat']);
            telatSby.push(terlambat7hr[v]['surabaya']['telat']);
          })

            this.karyawan = karyawan;
            this.tepat = tepat;
            this.telat = telat;
            console.log(this.telat)

            this.karyawanSby = karyawanSby;
            this.tepatSby = tepatSby;
            this.telatSby = telatSby;

          var TelatDatangChart = document.getElementById('TelatDatangChart');
          var cty = document.getElementById('PulangAwalChart');
          var KehadiranBandung = document.getElementById('KehadiranBandung');
          var KehadiranSurabaya = document.getElementById('KehadiranSurabaya');
          var terlambat7hr = document.getElementById('terlambat7hrBdg');
          var terlambat7hrSby = document.getElementById('terlambat7hrSby');

         var coloR = [];

          var dynamicColors = function() {
            var r = Math.floor(Math.random() * 255);
            var g = Math.floor(Math.random() * 255);
            var b = Math.floor(Math.random() * 255);
            return "rgb(" + r + "," + g + "," + b + ")";
          };

        


          for (var i in this.name) {
            coloR.push(dynamicColors());
          }
          
          //telat
          this.chart = new Chart(TelatDatangChart,{
            type: 'doughnut',
            data: {
              labels: this.kantor,
              datasets: [
                {
                  label: 'Jumlah ',
                  backgroundColor: ['rgb(0 128 0)', 'rgb(176 187 92)'],
                  borderColor: 'rgb(255 255 255)',
                  // fill: true,
                  data: this.jumlah_karyawan,
                  hoverBackgroundColor: 'rgb(2 171 2 / 91%)',
                  hoverBorderColor:"white"
                }
              ]
            },
            options: {
                // scales: {
                //     xAxes: [{
                //         stacked: true,
                //     }],
                //     yAxes: [{
                //         stacked: true,
                        
                //     }]
                // }, 
                // rotation: -Math.PI,
                cutoutPercentage: 50,
                // circumference: Math.PI,
                // legend: {
                //   position: 'center'
                // },
                animation: {
                  animateRotate: true,
                  animateScale: true
                },
                
                // scales: {
                //   yAxes: [{
                //       ticks: {
                //           min: 0,
                //           stepSize: 1
                //       }
                //   }]
                // },

                // legend: {
                //   display: false
                // // },
                // // tooltips: {
                // //     callbacks: {
                // //       label: function(tooltipItem) {
                // //               return tooltipItem.yLabel;
                // //       }
                // //     }
                // // }
            }
          });

          var hadir = typeof(this.kehadiran['bandung']['kehadiran']) !== 'undefined' ? this.kehadiran['bandung']['kehadiran'] : 0;
          var sakit = typeof(this.kehadiran['bandung']['S']) !== 'undefined' ? this.kehadiran['bandung']['S'] : 0;
          var ijin = typeof(this.kehadiran['bandung']['I']) !== 'undefined' ? this.kehadiran['bandung']['I'] : 0;
          var alpa = typeof(this.kehadiran['bandung']['A']) !== 'undefined' ? this.kehadiran['bandung']['A'] : 0;
          var cuti = typeof(this.kehadiran['bandung']['C']) !== 'undefined' ? this.kehadiran['bandung']['C'] : 0;
          var lk = typeof(this.kehadiran['bandung']['LK']) !== 'undefined' ? this.kehadiran['bandung']['LK'] : 0;
          
          this.chart = new Chart(KehadiranBandung,{
            type: 'bar',
            data: {
              labels: ['kehadiran', 'sakit', 'ijin', 'alpha', 'cuti', 'luar kota'],
              datasets: [
                {
                  label: 'Data Kehadiran',
                  backgroundColor: ['rgb(0 123 255)', 'rgb(63 81 181)', 'rgb(220 53 69)', 'rgb(239 255 1)', 'rgb(214 96 27)'],
                  borderColor: 'rgb(54, 162, 235)',
                  hoverBackgroundColor: 'rgb(2 171 2 / 91%)',
                  hoverBorderColor:"white",
                  fill: true,
                  data: [hadir, sakit, ijin, alpa, cuti, lk]
                }
              ]
            },
            options: {
              legend: {
                  display: false
              },
              tooltips: {
                  callbacks: {
                    label: function(tooltipItem) {
                            return tooltipItem.yLabel + " Orang";
                    }
                  }
              },
              scales: {
                  yAxes: [{
                      ticks: {
                          min: 0,
                          stepSize: 1
                      },
                      scaleLabel: {
                        display: true,
                        labelString: 'orang'
                      }
                  }]
              },
            }
          });

          var hadir = typeof(this.kehadiran['surabaya']['kehadiran']) !== 'undefined' ? this.kehadiran['surabaya']['kehadiran'] : 0;
          var sakit = typeof(this.kehadiran['surabaya']['S']) !== 'undefined' ? this.kehadiran['surabaya']['S'] : 0;
          var ijin = typeof(this.kehadiran['surabaya']['I']) !== 'undefined' ? this.kehadiran['surabaya']['I'] : 0;
          var alpa = typeof(this.kehadiran['surabaya']['A']) !== 'undefined' ? this.kehadiran['surabaya']['A'] : 0;
          var cuti = typeof(this.kehadiran['surabaya']['C']) !== 'undefined' ? this.kehadiran['surabaya']['C'] : 0;
          
          this.chart = new Chart(KehadiranSurabaya,{
            type: 'bar',
            data: {
              labels: ['kehadiran', 'sakit', 'ijin', 'alpha', 'cuti'],
              datasets: [
                {
                  backgroundColor: ['rgb(0 123 255)', 'rgb(63 81 181)', 'rgb(220 53 69)', 'rgb(239 255 1)', 'rgb(214 96 27)'],
                  borderColor: 'rgb(54, 162, 235)',
                  hoverBackgroundColor: 'rgb(2 171 2 / 91%)',
                  hoverBorderColor:"white",
                  fill: true,
                  data: [hadir, sakit, ijin, alpa, cuti]
                }
              ]
            },
            options: {
              legend: {
                  display: false
              },
              tooltips: {
                  callbacks: {
                    label: function(tooltipItem) {
                            return tooltipItem.yLabel + " Orang";
                    }
                  }
              },
              scales: {
                  yAxes: [{
                      ticks: {
                          min: 0,
                          stepSize: 1
                      },
                      scaleLabel: {
                        display: true,
                        labelString: 'orang'
                      }
                  }]
              },
            }
          });


          this.chart = new Chart(terlambat7hr,{
            type: 'bar',
            data: {
              labels: this.label,
              datasets: [
                {
                  // backgroundColor: ['red', 'red', 'red', 'red', 'red', 'red', 'red' , 'red'],
                  borderColor: 'red',
                  borderWidth:3,
                  lineTension:0.1,
                  label: 'Terlambat',
                  data: this.telat,
                },

              ]
            },
            options: {
              // legend: {
              //     display: false
              // },
              tooltips: {
                  callbacks: {
                    label: function(tooltipItem) {
                            return tooltipItem.yLabel + " Orang";
                    }
                  }
              },
              scales: {
                  yAxes: [{
                      ticks: {
                          min: 0,
                          stepSize: 1
                      },
                      scaleLabel: {
                        display: true,
                        labelString: 'orang'
                      }
                  }]
              },
            }
          });

          this.chart = new Chart(terlambat7hrSby,{
            type: 'bar',
            data: {
              labels: this.label,
              datasets: [
                {
                  // backgroundColor: ['red', 'red', 'red', 'red', 'red', 'red', 'red' , 'red'],
                  borderColor: 'red',
                  borderWidth:3,
                  lineTension:0.1,
                  label: 'Terlambat',
                  data: this.telatSby,
                },

              ]
            },
            options: {
              // legend: {
              //     display: false
              // },
              // tooltips: {
              //     callbacks: {
              //       label: function(tooltipItem) {
              //               return tooltipItem.yLabel;
              //       }
              //     }
              // },
              scales: {
                  yAxes: [{
                      ticks: {
                          min: 0,
                          stepSize: 1
                      }, 
                      scaleLabel: {
                        display: true,
                        labelString: 'orang'
                      }
                  }]
              }
            }
          });

          
        })
        .catch(error => {
          console.log(error);
          this.errored = true;
        })
        .finally(() => (this.loading = false));

    }
  }
  }
</script>