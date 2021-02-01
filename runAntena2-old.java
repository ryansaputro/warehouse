// TODO Auto-generated method stub
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

            try {
                
                //declartion variable to post on API								
                String timeStamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());
                String timeStampFormat = new SimpleDateFormat("HH:mm").format(Calendar.getInstance().getTime());
                String gate = "2";

                //jika button RFID dinyalakan
                if(BtnNyala == "true") {
                    
                    //insert process to post data on API
                    cekInsert = ApiMain.POST_tags_baru(id,gate,timeStamp);
                    
                }

                Thread.sleep(2000);
                
            } catch (IOException e) {
                
                // TODO Auto-generated catch block
                e.printStackTrace();
                System.out.println(e);
                
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            
        }
}