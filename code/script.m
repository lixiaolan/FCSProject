[tv1,cv1] = correlateFCS_TC('../testData/ZMW_100nm_Rh590Cl.out');
%[tv1,cv1] = correlateFCS_TC('../testData/ZMW_100nm_Rh590Cl_2.out');
%[tv1,cv1] = correlateFCS_TC('../testData/giant wells_Rh590Cl 1nM_2.out');
%[tv1,cv1] = correlateFCS_TC('../testData/giant wells_Rh590Cl 1nM.out');

plot(log10(tv1),cv1,'r',log10(CorrTimems/1000),Correlation12,'k');
