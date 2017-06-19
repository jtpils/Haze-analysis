function CPoint=gradhum(handles)
%% ������ȾԴģ��
xa=1:180;% x������
len_xa=length(xa);
ya=1:500;% y������
len_ya=length(ya);
%% ��ȾԴ����
gxq=handles.gxq;hgxq=handles.hgxq;
jkq=handles.jkq;hjkq=handles.hjkq;
xz=handles.xz;hxz=handles.hxz;
xq=handles.xq;hxq=handles.hxq;
gyt=handles.gyt;hgyt=handles.hgyt;
qj=handles.qj;hqj=handles.hqj;
lt=handles.lt;hlt=handles.hlt;
source=[gxq,jkq,xz,xq,gyt,qj,lt];
Q=[hgxq,hjkq,hxz,hxq,hgyt,hqj,hlt];%����ȾԴ����Ⱦǿ��
XY0=[8 40;32 110;35 40;58 60;80 95;56,25;160 220]; 
Loc={'����','������','Сկ','����','����̶','����','����'};
[num_source,~]=size(XY0);
%% ��������(��ʵ����б��)
fx=handles.fx;
Wind_level=handles.Wind_level;
a=(12-Wind_level)/12;
Wind_all=[
    -1 0;%����
    1 0;%����
    0 1;%�Ϸ�
    0 -1;%����
    -1 -1;%������
    -1 1;%���Ϸ�
    1 -1;%������
    1 1];%���Ϸ�
Wind=Wind_all(fx,:);
%% ��ʩʵʩ
Mea=[handles.M1,handles.M2,handles.M3]
Mea_level=handles.inle;
xishu=[0.5 0.4 0.2];
touru=1;
for i=1:3
    if(Mea(i)==1)
       Q=Q*(100-Mea_level*xishu(i))/100;
       touru=touru+Mea_level*xishu(i)*xishu(i)/100;
       Wind_level=Wind_level*(100-Mea_level*xishu(i))/100;
    end
end
%% ��ʼֵ�趨
CPoint=zeros(len_xa,len_ya);%����ϵ��Χ�ڸ���Ũ��
t=1;%ʱ���
for s=1:num_source
    if (source(s)==1)
        for x=1:1:len_xa
            for y=1:1:len_ya  
                xy=[(x-XY0(s,1)),y-XY0(s,2)];%����ȾԴ������
                xs=dot(Wind,xy)/(norm(Wind)*norm(xy));%�����������
                dd=(1-a)/2*xs+(1+a)/2;
                pud=dd*Q(s);
                CPoint(x,y)=CPoint(x,y)+pud*exp(-norm(xy)/((50+Wind_level*10)*t));
            end
        end
    end
end
%% ��������
tq=handles.tq;
Warea=handles.Warea;%�����仯��������
Wc=[1 1.2 1.4 0.84 0.7];%���磬���磬����������������
for x=Warea(1,1):Warea(2,1)
    for y=Warea(1,2):Warea(2,2)
        CPoint(x,y)=CPoint(x,y).*Wc(tq);
    end
end
CPoint= CPoint';
v=min(CPoint(:)):50:max(CPoint(:));
contourf(CPoint,v);grid on;colorbar;
for i=1:num_source
    if (source(i)==1)
        plot(XY0(i,1),XY0(i,2),'-dr','LineWidth',3);
    else
        plot(XY0(i,1),XY0(i,2),'-db','LineWidth',3);   
    end
    text(XY0(i,1),XY0(i,2)+10,Loc(i));
end
chanchu=sum(sum(CPoint<=200));
xiaoyi=num2str(chanchu/touru/10000);
wuran=num2str(sum(sum(CPoint>200))/180/5);
wuran=[wuran(1:5),'%'];
set(handles.prate,'string',wuran);
set(handles.outlevel,'string',xiaoyi);
end