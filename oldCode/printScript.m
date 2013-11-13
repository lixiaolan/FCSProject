hold on
plot(log10(CorrTimems/1000), Correlation12,'k.')
plot(log10(tv1),cv1,log10(tv2),cv2,log10(tv3),cv3,log10(tv4),cv4)
legend('Reference Data','1e-5 truncation','1e-6 truncation','1e-7 truncation','1e-8 truncation')
xlabel('log10(time)')
ylabel('Scaled Autocorelation')