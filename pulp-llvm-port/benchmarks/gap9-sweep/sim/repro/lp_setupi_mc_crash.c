int work(void){int acc=0;for(int i=0;i<1000;i++)acc+=i^(acc>>3);return acc;}
