% Date times imported from datasheet as datetime by manually manipulating column
% size and changing imput type to datetime custom

figure(1)
subplot(3,1,1)
plot(Bogo_DateTime, Bogo_Peak_Current, '.')
xlabel('Date')
ylabel('Peak Current')
title('Bogoslof 5/28')

subplot(3,1,2)
histogram(Bogo_Peak_Current, edges, 'Normalization', 'count')
xlabel('Peak Current')
ylabel('stroke count')

subplot(3,1,3)
BDT = datenum(Bogo_DateTime);
hist(BDT, (min(BDT):1/1440:max(BDT)))
datetick('x')
xlabel('Date')
ylabel('Strokes per minute')
grid ON

suptitle('Vaisala Ltg Data of Bogoslof 5/28/2017')

figure(2)
subplot(3,1,1)
plot(Grim_DateTime, Grim_Peak_Current, '.')
xlabel('Date')
ylabel('Peak Current')
title('Grimsvotn 2011')

subplot(3,1,2)
histogram(Grim_Peak_Current, 'Normalization', 'count')
xlabel('Peak Current')
ylabel('stroke count')

subplot(3,1,3)
GDT = datenum(Grim_DateTime);
hist(GDT, (min(GDT):1/1440:max(GDT)))
datetick('x')
xlabel('Date')
ylabel('Strokes per minute')
grid ON

suptitle('Vaisala Ltg Data of Grimsvotn 2011')