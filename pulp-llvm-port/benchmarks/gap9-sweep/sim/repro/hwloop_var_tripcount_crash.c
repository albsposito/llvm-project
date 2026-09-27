int work(int n){int acc=0;for(int i=0;i<n;i++)acc+=i^(acc>>3);return acc;}
