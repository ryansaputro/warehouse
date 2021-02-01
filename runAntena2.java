private static void runAntena2() {
		
		textArea.append("antena 02 berhasil diaktifkan...\n");
		Thread run_antena = new Thread(new Runnable(){
			@SuppressWarnings("unchecked")
			@Override
			public void run(){
				
//				Date onClickAnten = new Date();
//				System.out.println("antena aktif tgl : "+onClickAnten);
				Calendar calendar = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
				calendar.add(Calendar.SECOND, 5);
				System.out.println("kalender : "+calendar.getTime());
				
				List<HashMap<String,String>> listx;
				listx = (ArrayList<HashMap<String,String>>)reader_ip201.read().getData();

				
				System.out.println("cek total Total : "+listx.size());
				
				try {
										
					jmlLooping = 1;

				    //check data if more than 5*1000 there is no data the antenn will off automatically
						while (true) {
				        	System.out.println(new Date());
				        	Thread.sleep(5 * 1000);
				        	
				        	if((jmlLooping <= 5) && (listx.size() > 0)) {
				            	System.out.println("Tag terdeteksi");
				            	while(reader_ip201.isActive()==true){
							        
							        //showing in text box						
							        textArea.append("\n");
							        textArea.append("====== TAG ID Terdeteksi ======\n");
							        textArea.append("tunggu...\n");
							    
							        //declartion new variables from reader detected tag						
							        List<HashMap<String,String>> list;
							        list = (ArrayList<HashMap<String,String>>)reader_ip201.read().getData();

							        //looping for detected tag from reader						
							        for(int i=0,iLen = list.size();i<iLen;i++){

							            id = list.get(i).get("ID");
							            textArea.append("Tag terdeteksi : "+id+"\n");
							            System.out.println("ID : "+id);
							    
							            //declartion variable to post on API								
							            String timeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());
//							            String timeStampFormat = new SimpleDateFormat("HH:mm").format(Calendar.getInstance().getTime());
							            String gate = "2";

							            //jika button RFID dinyalakan
							            if(BtnNyala == "true") {
							                
							                //insert process to post data on API
							                cekInsert = ApiMain.POST_tags_baru(id,gate,timeStamp);
							                jmlLooping = 1;
							            }
							            //end if Btn is nyala
							            
							        }
							        //endfor tag detected
							        
							    }
				            	//end while from tag detected
				            	
				        	}else if((jmlLooping >= 6)) {
				        		
				        		if(listx.size() == 0) {
				        			//check status absen
					        		if(reader_ip201.isActive()==true) {
					        			System.out.println("Tag tdk terdeteksi absen akan dimatikan");
					        			ActionBtnMatikan2();
					        		}else {
					        			System.out.println("Tag tdk terdeteksi reader sudah dimatikan");
					        		}
				        		}else {
				        			runAntena2();
					        		System.out.println("Antena On");
				        		}
				  
				        	}
				        
				        	System.out.println("looping ke : "+jmlLooping);
				        	jmlLooping++;
				    	} 
						
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				            
			}

			private void ActionBtnMatikan2() {
				// TODO Auto-generated method stub
				try {
					textArea.append("\n");
					textArea.append("====== Antena 02 Sedang Dimatikan ======\n");
					textArea.append("mohon tunggu...\n");
					
					//give variable to false to stop push notif to websocket
					BtnNyala = "false";
					
					Boolean koneksi = cek_koneksi();
//					if(koneksi == true) {
						btnOff2.setEnabled(false);
						btnOn2.setEnabled(true);
						reader_ip201.closeRF();
						reader_ip201.disconnect();
						textArea.append("Antena 02 berhasil dimatikan...\n");
						tfStatus2.setText("mati");
						jmlLooping = 1;
//					}else {
//						tfStatus2.setText("koneksi gagal");
//						textArea.append("koneksi gagal...\n");
//						textArea.append("mohon periksa internet anda...\n");
//					}
				}catch (Exception e) {
					System.out.println(e.toString());
				}
				
			}
		});
		run_antena.start();
	}