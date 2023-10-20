
CREATE TABLE CIT_SLICE_BUCKETS
(
  SLICE    VARCHAR2(5 CHAR),
  BUCKET1  VARCHAR2(30 CHAR),
  BUCKET2  VARCHAR2(30 CHAR),
  BUCKET3  VARCHAR2(30 CHAR),
  BUCKET4  VARCHAR2(30 CHAR),
  BUCKET5  VARCHAR2(30 CHAR),
  BUCKET6  VARCHAR2(30 CHAR),
  BUCKET7  VARCHAR2(30 CHAR)
)
TABLESPACE DATA
;

begin
  delete from cit_slice_buckets;
  commit;
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S00', upper(trim('1500')), upper(trim('10000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S01', upper(trim('15000')), upper(trim('100000')), upper(trim('1000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S02', upper(trim('35000')), upper(trim('250000')), upper(trim('2500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S03', upper(trim('50000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S04', upper(trim('3000')), upper(trim('20000')), upper(trim('200000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S05', upper(trim('465000')), upper(trim('3100000')), upper(trim('31000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S06', upper(trim('1000000')), upper(trim('5000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S07', upper(trim('25000')), upper(trim('200000')), upper(trim('1250000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S08', upper(trim('40000')), upper(trim('200000')), upper(trim('400000')), upper(trim('1000000')), upper(trim('Over')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S09', upper(trim('2500')), upper(trim('15000')), upper(trim('150000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S10', upper(trim('4800')), upper(trim('32000')), upper(trim('320000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S11', upper(trim('15000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S12', upper(trim('20000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S13', upper(trim('77500')), upper(trim('775000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S14', upper(trim('16500')), upper(trim('1100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S15', upper(trim('110000')), upper(trim('1100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S16', upper(trim('10000')), upper(trim('75000')), upper(trim('750000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S17', upper(trim('12500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S18', upper(trim('10000')), upper(trim('50000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S19', upper(trim('50000')), upper(trim('300000')), upper(trim('3000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S20', upper(trim('500000')), upper(trim('5000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S21', upper(trim('2500')), upper(trim('12500')), upper(trim('25000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S22', upper(trim('400000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S23', upper(trim('25000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S24', upper(trim('3750000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S25', upper(trim('8000')), upper(trim('20000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S26', upper(trim('2500')), upper(trim('12500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S27', upper(trim('300000')), upper(trim('800000')), upper(trim('2000000')), upper(trim('5000000')), upper(trim('12000000')), upper(trim('Over')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S28', upper(trim('10000')), upper(trim('73000')), upper(trim('730000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S29', upper(trim('250000')), upper(trim('25000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S30', upper(trim('5000')), upper(trim('12500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S31', upper(trim('13500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S32', upper(trim('3000')), upper(trim('15000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S33', upper(trim('5000')), upper(trim('20000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S34', upper(trim('200')), upper(trim('1000')), upper(trim('10000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S35', upper(trim('100000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S36', upper(trim('10000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S37', upper(trim('10000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S38', upper(trim('5000')), upper(trim('20000')), upper(trim('100000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S39', upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S40', upper(trim('15000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S41', upper(trim('1000')), upper(trim('10000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S42', upper(trim('250000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S43', upper(trim('1500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S44', upper(trim('500000')), upper(trim('3000000')), upper(trim('30000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S45', upper(trim('5000000')), upper(trim('10000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S46', upper(trim('50000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S47', upper(trim('70000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S48', upper(trim('16500')), upper(trim('110000')), upper(trim('1100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S49', upper(trim('10000')), upper(trim('50000')), upper(trim('100000')), upper(trim('275000')), upper(trim('Over')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S50', upper(trim('1570')), upper(trim('10500')), upper(trim('105000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S51', upper(trim('2000')), upper(trim('15000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S52', upper(trim('1000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S53', upper(trim('1000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S54', upper(trim('2500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S55', upper(trim('10000')), upper(trim('25000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S56', upper(trim('735000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S57', upper(trim('5000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S58', upper(trim('3500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S59', upper(trim('5000')), upper(trim('20000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S60', upper(trim('1500')), upper(trim('10000')), upper(trim('100000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S61', upper(trim('5000')), upper(trim('10000')), upper(trim('15000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S62', upper(trim('10000')), upper(trim('15000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S63', upper(trim('1000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S64', upper(trim('250')), upper(trim('2500')), upper(trim('12500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S65', upper(trim('1000')), upper(trim('10000')), upper(trim('50000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S66', upper(trim('26500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S67', upper(trim('18500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S68', upper(trim('3500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S69', upper(trim('1000000')), upper(trim('10000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S70', upper(trim('100000')), upper(trim('1000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S71', upper(trim('10000')), upper(trim('50000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S72', upper(trim('500')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S73', upper(trim('500000')), upper(trim('10000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S74', upper(trim('300000')), upper(trim('800000')), upper(trim('2000000')), upper(trim('5000000')), upper(trim('8500000')), upper(trim('12000000')), upper(trim('Over')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S75', upper(trim('500')), upper(trim('10000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S76', upper(trim('5000')), upper(trim('50000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S77', upper(trim('50000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S78', upper(trim('50000')), upper(trim('100000')), upper(trim('250000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S79', upper(trim('10000')), upper(trim('50000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S80', upper(trim('2500')), upper(trim('25000')), upper(trim('125000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S81', upper(trim('1500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S82', upper(trim('1700000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S83', upper(trim('15000')), upper(trim('30000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S84', upper(trim('2500')), upper(trim('40000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S85', upper(trim('10000')), upper(trim('50000')), upper(trim('400000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S86', upper(trim('7000')), upper(trim('45000')), upper(trim('450000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S87', upper(trim('11000')), upper(trim('75000')), upper(trim('750000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S88', upper(trim('200000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S89', upper(trim('3000')), upper(trim('100000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S90', upper(trim('500000')), upper(trim('1000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S91', upper(trim('150000')), upper(trim('300000')), upper(trim('800000')), upper(trim('2000000')), upper(trim('Over')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S92', upper(trim('1500000000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S93', upper(trim('6000')), upper(trim('200000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  insert into cit_slice_buckets (slice, Bucket1, Bucket2, Bucket3, Bucket4, Bucket5, Bucket6, Bucket7) values ('S94', upper(trim('15000')), upper(trim('500000')), upper(trim('Over')), upper(trim('')), upper(trim('')), upper(trim('')), upper(trim('')));
  commit;  
end;
/

CREATE TABLE CIT_CHECK_OPCODE_BU
(
  REFINDIVIDU       VARCHAR2(10 CHAR),
  FEE_CODE          VARCHAR2(30 CHAR),
  EXIST_IN_DOMAINE  VARCHAR2(1 CHAR),
  EXIST_IN_BU       VARCHAR2(1 CHAR),
  CURR              VARCHAR2(3 CHAR),
  BU_NAME           VARCHAR2(100 CHAR),
  ABREV_FEE_CODE    VARCHAR2(20 CHAR)
)
TABLESPACE DATA;

create table cit_fee_code_interet
(
 FEE_CODE    VARCHAR2(15 CHAR),
 produit     VARCHAR2(15 CHAR),
 devise      VARCHAR2(3 CHAR),
 ref_lvl     VARCHAR2(15 CHAR),
 reftype_lvl VARCHAR2(3 CHAR),
 codeit      VARCHAR2(8 CHAR),
 type        VARCHAR2(1 CHAR),
 period      NUMBER(3),
 case_phase  VARCHAR2(15 CHAR),
 MT_MAX      NUMBER(16,2)
)
TABLESPACE DATA;

create table cit_fee_code_domaine
(
 type       VARCHAR2(40 CHAR),
 abrev      VARCHAR2(15 CHAR),
 valeur     VARCHAR2(200 CHAR),
 abrev_an   VARCHAR2(15 CHAR),
 valeur_an  VARCHAR2(200 CHAR)
 )
TABLESPACE DATA;

create table cit_fee_code_error
(
 the_error       VARCHAR2(500 CHAR),
 the_date        date
 )
TABLESPACE DATA;

CREATE OR REPLACE procedure cit_feecode_bu
as
/*
 BEVRIG1
 procedure checking if a FEE_CODE exist (if not preparation in CIT tables)
 and if it is well linked to BU/Currency

--Examples of calls:
 --To check for one BU
 begin
  delete from CIT_DEBUG_MESSAGES;
  commit;
  delete from cit_check_opcode_bu;
  insert into cit_check_opcode_bu(bu_name, fee_code, curr) values('HDITA', 'S00_07-07-06-05', 'EUR');
  insert into cit_check_opcode_bu(bu_name, fee_code, curr) values('HDITA', 'S00_09-08-07-06', 'EUR');
  commit;
  cit_feecode_bu;
  commit;
end;
/
-- to insert slices in ALL BUs
declare 
  cursor c_bu
  is
    select i.cle_cl as HD, i.nom as HD_Name, b.refindividu as BU_IMX
      from g_bu b, g_individu i
    where b.refindividu = i.refindividu order by 1;
  r_bu c_bu%rowtype;
begin
  delete from CIT_DEBUG_MESSAGES;
  commit;
  delete from cit_check_opcode_bu;
  open c_bu;
  loop
    fetch c_bu into r_bu;
    exit when c_bu%notfound;
    insert into cit_check_opcode_bu(bu_name, fee_code, curr) values(r_bu.hd, 'FX-RTE_19.5', 'USD');
    insert into cit_check_opcode_bu(bu_name, fee_code, curr) values(r_bu.hd, 'FX-RTE_19.5', 'SGD');
  end loop;
  close c_bu;
  commit;
  cit_feecode_bu;
  commit;  
end;
/  
-- to insert a slice several BUs
declare 
  TYPE hd_array IS TABLE OF VARCHAR2(10);
  the_array hd_array;
begin
  delete from CIT_DEBUG_MESSAGES;
  commit;
  delete from cit_check_opcode_bu;
  the_array := hd_array('HDBEL', 'HDCZE', 'HDDEU', 'HDDNK', 'HDESP', 'HDFRA');  -- BUs
  for idx IN the_array.FIRST..the_array.LAST LOOP
    insert into cit_check_opcode_bu(bu_name, fee_code, curr) values(the_array(idx), 'S89_17-14-8', 'GBP');
    commit;
  end loop;
  cit_feecode_bu;
  commit;  
end;
/  
to see traces:  select * from CIT_DEBUG_MESSAGES order by seq;
*/
  cursor c1 
  is 
    select bu_name, refindividu, fee_code, curr 
      from cit_check_opcode_bu
     where exist_in_bu is null
  ;
  r1 c1%rowtype;
  --
  cursor c_imx(p_hd in varchar2)
  is
    select b.refindividu
      from g_bu b
         , g_individu i
     where 1 = 1 
       and i.cle_cl = p_hd
       and b.refindividu = i.refindividu
  ;
  r_imx c_imx%rowtype;
  --
  cursor c_dom(p_valeur in varchar2)
  is
   select abrev
     from v_domaine 
    where type = 'FEE_CODES' 
      and valeur = p_valeur;
  r_dom c_dom%rowtype;
  --
  cursor c_bu(p_refindividu in varchar2, p_curr in varchar2, p_fee_code in varchar2)
  is
    select 1 from g_interet i
      where i.reftype_lvl = 'BU'
        and i.ref_lvl = p_refindividu
        and i.type = 'H'
        and i.devise = p_curr
        and i.fee_code = p_fee_code
  ;
  r_bu c_bu%rowtype;
  --
  cursor c_create
  is
    select distinct fee_code 
      from cit_check_opcode_bu o
     where refindividu is not null 
       and exist_in_domaine = 'N'
     order by fee_code
  ;
  r_create c_create%rowtype;
  --
  cursor c_fee_id
  is
    select abrev from v_domaine 
     where type = 'FEE_CODES'
       and abrev like 'FC%'
     order by abrev desc
  ;
  r_fee_id c_fee_id%rowtype;
  --
  cursor c_create_BU 
  is
    select distinct o.refindividu, i.nom, fee_code, curr, exist_in_domaine, abrev_fee_code, exist_in_bu 
      from cit_check_opcode_bu o, g_individu i
     where o.refindividu is not null
       and o.exist_in_bu = 'N'
       and i.refindividu = o.refindividu
  order by i.nom, fee_code
  ;
  r_create_BU c_create_BU%rowtype;
  --
   cursor c_slice(p_slice in varchar2) 
    is
      select * from cit_slice_buckets 
       where slice = p_slice
    ;
    r_slice c_slice%rowtype;
  --
  l_error varchar2(1000);
  bo_error boolean;
  l_fee_key varchar2(20);
  l_fee varchar2(100);
  l_fee2 varchar2(100);
  l_slice varchar2(10);
  l_pos number;
  l_bo_FX boolean;
  l_amt number;
  l_count_amt_fee number;
  l_count_amt_slice number;
  --
  function check_bad_fee_code(p_fee_code in varchar2, p_error in out varchar2)
    return boolean
  is
    error_message varchar2(200); 
  begin
    delete from cit_fee_code_domaine;
    delete from cit_fee_code_interet;
    commit;
    l_fee := p_fee_code;
    cit_debug.write('check_bad_fee_code - Fee Code: ' || p_fee_code);
    bo_error := false;
    l_bo_FX := false;
    l_count_amt_fee := 0;
    l_count_amt_slice := 0;
    -- to have the slice type of the fee code
    l_pos := instr(l_fee, '_');
    if l_pos = 0 then
      bo_error := true;
      error_message := 'Fee codes does not contains the mandatory underscore character: ' || l_fee;
      cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
    else
      l_slice := substr(l_fee, 1, l_pos - 1);
      cit_debug.write('check_bad_fee_code - Slice: ' || l_slice);
      l_fee2 := substr(l_fee, l_pos + 1, length(l_fee));
      cit_debug.write('check_bad_fee_code - Following: ' || l_fee2);
      if substr(l_slice,1,2) = 'FX' then
        cit_debug.write('check_bad_fee_code - Fixed rate ' || l_fee);
        l_bo_FX := true;
      else
        l_bo_FX := false;
      end if;
    end if;
    if bo_error = false then
      -- for FX rate, just to check if we have just an amount on the end 
      if l_bo_FX = true then
        if substr(l_fee2, 1, 1) = 'L' then
          cit_debug.write('check_bad_fee_code - FX rate LEGAL only detected');
          begin
            l_amt := to_number(substr(l_fee2, 2, length(l_fee2)));
          exception
            when others then
              bo_error := true;
              error_message := 'Cannot convert the fixed rate to amount: ' || l_fee;
              cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
          end;
          if bo_error = false then
            cit_debug.write('check_bad_fee_code - FX rate LEGAL ONLY: ' || l_amt);
          end if;
        elsif instr(l_fee2, 'L') > 0 then
          cit_debug.write('check_bad_fee_code - FX rate AMIC INSOL LEGAL detected');
          l_pos := instr(l_fee2, 'L');
          begin
            l_amt := to_number(substr(l_fee2, 1, l_pos - 2));
          exception
            when others then
              bo_error := true;
              error_message := 'Cannot convert the first fixed rate to amount: ' || l_fee;
              cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
          end;
          if bo_error = false then
            cit_debug.write('check_bad_fee_code - FX rate AMIC INSOL Amount: ' || l_amt);
            l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            cit_debug.write('check_bad_fee_code - Remaining: ' || l_fee2);
            begin
              if substr(l_fee2, 1, 1) = '+' then
                l_amt := l_amt + to_number(substr(l_fee2, 2, length(l_fee2)));
              else
                l_amt := to_number(l_fee2);
              end if;
            exception
            when others then
              bo_error := true;
              error_message := 'Cannot convert the second fixed rate to amount: ' || l_fee;
              cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
            end;
            if bo_error = false then
              cit_debug.write('check_bad_fee_code - FX rate LEGAL Amount: ' || l_amt);
            end if;
          end if;
        else -- FX classic
          begin
            l_amt := to_number(l_fee2);
          exception
            when others then
              bo_error := true;
              error_message := 'Cannot convert the fixed rate to amount: ' || l_fee;
              cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
          end;
          if bo_error = false then
            cit_debug.write('check_bad_fee_code - Amount: ' || l_amt);
            null; 
          end if;
        end if;  
      else
        if substr(l_slice,1,1) = 'S' then
           open c_slice(l_slice);
           fetch c_slice into r_slice;
           if c_slice%notfound then
             bo_error := true;
             error_message := 'The slice ' || l_slice || ' is unknown in the table cit_slice_buckets: ' || l_fee;
             cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
           else
             cit_debug.write('check_bad_fee_code - Slice ' || l_slice || ' is knwon in the table cit_slice_buckets');
             --to check if we have the good number of amounts
             if r_slice.bucket7 is not null then
               l_count_amt_slice := 7;
             elsif r_slice.bucket6 is not null then
               l_count_amt_slice := 6; 
             elsif r_slice.bucket5 is not null then
               l_count_amt_slice := 5;
             elsif r_slice.bucket4 is not null then
               l_count_amt_slice := 4;
             elsif r_slice.bucket3 is not null then
               l_count_amt_slice := 3;
             elsif r_slice.bucket2 is not null then
               l_count_amt_slice := 2;
             else
                bo_error := true;
                error_message := 'The slice ' || l_slice || ' is incorrect in the table cit_slice_buckets: ' || l_fee;
                cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
             end if;
             if bo_error = false then
               cit_debug.write('check_bad_fee_code - Number of amount to have in the fee code: ' || l_count_amt_slice); 
               null;
             end if;
             -- to get the amounts
             cit_debug.write('check_bad_fee_code - Checking the amounts in string: ' || l_fee2);
             l_pos := instr(l_fee2, '-');
             while l_pos <> 0 and bo_error = false loop
               begin
                 l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
               exception
                 when others then
                   bo_error := true;
                   error_message := 'Cannot convert ' || substr(l_fee2, 1, l_pos - 1) || ' to amount : '|| l_fee;
                   cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
               end;
               if bo_error = false then
                 l_count_amt_fee := l_count_amt_fee + 1;
                 l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
                 l_pos := instr(l_fee2, '-');
                 cit_debug.write('check_bad_fee_code - Find amount num ' || l_count_amt_fee || ' - value ' || l_amt);
                 cit_debug.write('  l_fee2 =  ' || l_fee2);
                 cit_debug.write('  l_pos =  ' || l_pos);
               end if;
               -- if l_count_amt_fee = 3 then bo_error := true; end if;
             end loop;
             -- to take the last amount
             if l_pos = 0 and bo_error = false then
                begin
                  l_amt := to_number(l_fee2);
                exception
                  when others then
                    bo_error := true;
                    error_message := 'Cannot convert ' || l_fee2 || ' to amount : '|| l_fee;
                    cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
                end;
                if bo_error = false then
                 l_count_amt_fee := l_count_amt_fee + 1;
                 cit_debug.write('check_bad_fee_code - Find amount num ' || l_count_amt_fee || ' - value ' || l_amt);
               end if;
             end if;
           
             if bo_error = false and l_count_amt_fee <>  l_count_amt_slice then
                bo_error := true;
                error_message := 'Wrong number of amounts in the fee code, we have ' || l_count_amt_fee || ' amounts, and we should have: '|| l_count_amt_slice || ' amounts';
                cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
             end if;
             
           end if; -- slice found
           close c_slice;
        else -- neither S slice
            bo_error := true;
            error_message := 'The FEE CODE must start with S or FX: ' || l_fee;
            cit_debug.write('check_bad_fee_code - ERROR: ' || error_message);
        end if;   
      end if; -- FX or S
    end if; -- bo error = false
    
    if bo_error = false then
      cit_debug.write('check_bad_fee_code - SUCCESS: ' || l_fee);
    end if;
    
    p_error := error_message;
    return bo_error;
  end; -- function check_bad_fee_code
begin
  cit_debug.write('START of handling of FEE CODE');
  -- Checking the presence of fee codes in v_domaine and in BU
  --   in table cit_check_opcode_bu
  update cit_check_opcode_bu set exist_in_domaine = null, exist_in_bu = null; 
  open c1;
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    open c_imx(r1.bu_name);
    fetch c_imx into r_imx;
    if c_imx%found then
      update cit_check_opcode_bu 
         set refindividu = r_imx.refindividu
       where bu_name  = r1.bu_name          
         and fee_code = r1.fee_code
         and curr = r1.curr
      ;
    end if;
    close c_imx;
  end loop;
  close c1;
  open c1;
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    if r1.refindividu is null then
      cit_debug.write('HD Name error - ERROR: ' || r1.bu_name);
    else
      --cit_debug.write('check fee_code r1 ' ||  r1.fee_code);
      open c_dom(r1.fee_code);
      fetch c_dom into r_dom;
      if c_dom%found then
        --cit_debug.write('check fee_code  ' ||   r_dom.abrev || ' - ' ||  r1.refindividu || ' - ' ||  r1.curr);
        open c_bu(r1.refindividu, r1.curr, r_dom.abrev);
        fetch c_bu into r_bu;
        if c_bu%found then
          update cit_check_opcode_bu 
             set exist_in_domaine = 'Y'
                ,exist_in_bu = 'Y'
                ,abrev_fee_code = r_dom.abrev
           where refindividu = r1.refindividu
             and fee_code = r1.fee_code
             and curr = r1.curr
          ;
        else
          update cit_check_opcode_bu 
             set exist_in_domaine = 'Y'
                ,exist_in_bu = 'N'
                ,abrev_fee_code = r_dom.abrev
          where refindividu = r1.refindividu
             and fee_code = r1.fee_code
             and curr = r1.curr
            ;
        end if;
        close c_bu;
      else
        update cit_check_opcode_bu 
           set exist_in_domaine = 'N'
              ,exist_in_bu = 'N'
        where refindividu = r1.refindividu
           and fee_code = r1.fee_code
           and curr = r1.curr
        ;
      end if;
      commit;
      close c_dom;
    end if;
  end loop;
  close c1;
  
  -- do we have fee_codes to create, if yes, are they correct
  bo_error := false;
  open c_create;
  loop
    fetch c_create into r_create;
    exit when c_create%notfound or bo_error = true;
    if check_bad_fee_code(r_create.fee_code,l_error) = true then
      cit_debug.write('ERROR: Fee Code: <' || r_create.fee_code || '> : ' || l_error);
      bo_error := true;
    end if;
  end loop;
  close c_create;
  
  if bo_error = false then
    open c_create;
    loop
      fetch c_create into r_create;
      exit when c_create%notfound or bo_error = true;
      
      open c_fee_id;
      fetch c_fee_id into r_fee_id;
      if c_fee_id%found then
      
        l_fee_key := 'FC5' || trim(to_char(to_number(substr(trim(r_fee_id.abrev), 4, length(trim(r_fee_id.abrev)))) + 1, '099999'));
        cit_debug.write('Create Fee Code: <' || r_create.fee_code || '> : ' || l_fee_key);
        
        begin
          insert into cit_fee_code_domaine(type, abrev, valeur, abrev_an, valeur_an)
           values('FEE_CODES', l_fee_key, r_create.fee_code, l_fee_key, r_create.fee_code);
           
          update cit_check_opcode_bu
             set abrev_fee_code = l_fee_key
           where fee_code = r_create.fee_code;
           
        exception
          when others then
            bo_error := true;
            cit_debug.write('ERROR Exception: ' || sqlerrm);
        end;
      end if;
      close c_fee_id;
      
      commit;
      
    end loop;
    close c_create;
  end if; -- bo_error = false;
  
  -- inserting the fee codes rows into cit_fee_code_interet (BU link)
  if bo_error = false then
    open c_create_BU;
    loop
      fetch c_create_BU into r_create_BU;
      exit when c_create_BU%notfound;
      l_fee := r_create_BU.fee_code;
      cit_debug.write('Working for : ' || l_fee);
      l_pos := instr(l_fee, '_');
      l_slice := substr(l_fee, 1, l_pos - 1);
      cit_debug.write('Slice: ' || l_slice);
      l_fee2 := substr(l_fee, l_pos + 1, length(l_fee));
      cit_debug.write('Following: ' || l_fee2);
      
      if substr(l_slice,1,2) = 'FX' then
      
        if substr(l_fee2, 1, 1) = 'L' then
          l_amt := to_number(substr(l_fee2, 2, length(l_fee2)));
          cit_debug.write('FX rate LEGAL ONLY: ' || l_amt);
          insert into cit_fee_code_interet(FEE_CODE      -- Fee Code Id
                                 ,produit     -- 'LEGAL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,case_phase  -- 'COLL'
                                 ) 
               values(r_create_BU.abrev_fee_code
                     ,'LEGAL'
                     ,r_create_BU.curr
                     ,r_create_BU.refindividu
                     ,'BU'
                     ,l_amt
                     ,'H'
                     ,1
                     ,'COLL'
                     );
        elsif instr(l_fee2, 'L') > 0 then
          cit_debug.write('FX rate AMIC INSOL LEGAL detected');
          l_pos := instr(l_fee2, 'L');
          l_amt := to_number(substr(l_fee2, 1, l_pos - 2));
          cit_debug.write('FX rate AMIC INSOL Amount: ' || l_amt);
          insert into cit_fee_code_interet(FEE_CODE      -- Fee Code Id
                                 ,produit     -- 'LEGAL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,case_phase  -- 'COLL'
                                 ) 
               values(r_create_BU.abrev_fee_code
                     ,'AMIC'
                     ,r_create_BU.curr
                     ,r_create_BU.refindividu
                     ,'BU'
                     ,l_amt
                     ,'H'
                     ,1
                     ,'COLL'
                     );
          insert into cit_fee_code_interet(FEE_CODE      -- Fee Code Id
                                 ,produit     -- 'LEGAL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,case_phase  -- 'COLL'
                                 ) 
               values(r_create_BU.abrev_fee_code
                     ,'INSOL'
                     ,r_create_BU.curr
                     ,r_create_BU.refindividu
                     ,'BU'
                     ,l_amt
                     ,'H'
                     ,1
                     ,'COLL'
                     );
          l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
          cit_debug.write(' Remaining: ' || l_fee2);
          if substr(l_fee2, 1, 1) = '+' then
            l_amt := l_amt + to_number(substr(l_fee2, 2, length(l_fee2)));
          else
            l_amt := to_number(l_fee2);
          end if;
          cit_debug.write('FX rate LEGAL Amount: ' || l_amt);
          insert into cit_fee_code_interet(FEE_CODE      -- Fee Code Id
                                 ,produit     -- 'LEGAL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,case_phase  -- 'COLL'
                                 ) 
               values(r_create_BU.abrev_fee_code
                     ,'LEGAL'
                     ,r_create_BU.curr
                     ,r_create_BU.refindividu
                     ,'BU'
                     ,l_amt
                     ,'H'
                     ,1
                     ,'COLL'
                     );
        else -- FX classic
          begin
            l_amt := to_number(l_fee2);
          exception -- I keep the exception for the case of FX-RTE_10-L18
            when others then
              bo_error := true;
              cit_debug.write('ERROR: Cannot convert the fixed rate to amount: ' || l_fee);
          end;
          if bo_error = false then
            cit_debug.write('Insert Amount: ' || l_amt || ' for BU '|| r_create_BU.nom || ' - currency ' 
                                 || r_create_BU.curr || ' - ' || r_create_BU.fee_code || ' - key ' || r_create_BU.abrev_fee_code);
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ) 
               values(r_create_BU.abrev_fee_code
                     ,'COLL'
                     ,r_create_BU.curr
                     ,r_create_BU.refindividu
                     ,'BU'
                     ,l_amt
                     ,'H'
                     ,1
                     );
          end if;
        end if;
      else -- S
        cit_debug.write('Type S');
        cit_debug.write('Insert for BU '|| r_create_BU.nom || ' - currency ' 
                               || r_create_BU.curr || ' - ' || r_create_BU.fee_code);
        open c_slice(l_slice);
        fetch c_slice into r_slice;
        if c_slice%found then
          if r_slice.bucket1 is not null then
            -- Get first amount 
            l_pos := instr(l_fee2, '-');
            l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
            l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            cit_debug.write('Insert Bucket1: ' || r_slice.bucket1 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                     ,r_create_BU.curr
                     ,r_create_BU.refindividu
                     ,'BU'
                     ,l_amt
                     ,'H'
                     ,1
                     ,r_slice.bucket1
                     );
          end if;
          if r_slice.bucket2 is not null then
            if r_slice.bucket2 = 'OVER' then
              l_amt := to_number(l_fee2);
            else
              l_pos := instr(l_fee2, '-');
              l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
              l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            end if;
            cit_debug.write('Insert Bucket2: ' || r_slice.bucket2 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                      ,r_create_BU.curr
                      ,r_create_BU.refindividu
                      ,'BU'
                      ,l_amt
                      ,'H'
                      ,1
                      ,decode(r_slice.bucket2, 'OVER', null, r_slice.bucket2)
                      );
          end if;
          if r_slice.bucket3 is not null then
            if r_slice.bucket3 = 'OVER' then
              l_amt := to_number(l_fee2);
            else
              l_pos := instr(l_fee2, '-');
              l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
              l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            end if;
            cit_debug.write('Insert Bucket3: ' || r_slice.bucket3 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                      ,r_create_BU.curr
                      ,r_create_BU.refindividu
                      ,'BU'
                      ,l_amt
                      ,'H'
                      ,1
                      ,decode(r_slice.bucket3, 'OVER', null, r_slice.bucket3)
                      );
          end if;
          if r_slice.bucket4 is not null then
            if r_slice.bucket4 = 'OVER' then
              l_amt := to_number(l_fee2);
            else
              l_pos := instr(l_fee2, '-');
              l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
              l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            end if;
            cit_debug.write('Insert Bucket4: ' || r_slice.bucket4 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                      ,r_create_BU.curr
                      ,r_create_BU.refindividu
                      ,'BU'
                      ,l_amt
                      ,'H'
                      ,1
                      ,decode(r_slice.bucket4, 'OVER', null, r_slice.bucket4)
                      );
          end if;
          if r_slice.bucket5 is not null then
            if r_slice.bucket5 = 'OVER' then
              l_amt := to_number(l_fee2);
            else
              l_pos := instr(l_fee2, '-');
              l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
              l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            end if;
            cit_debug.write('Insert Bucket5: ' || r_slice.bucket5 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                      ,r_create_BU.curr
                      ,r_create_BU.refindividu
                      ,'BU'
                      ,l_amt
                      ,'H'
                      ,1
                      ,decode(r_slice.bucket5, 'OVER', null, r_slice.bucket5)
                      );
          end if;
          if r_slice.bucket6 is not null then
            if r_slice.bucket6 = 'OVER' then
              l_amt := to_number(l_fee2);
            else
              l_pos := instr(l_fee2, '-');
              l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
              l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            end if;
            cit_debug.write('Insert Bucket6: ' || r_slice.bucket6 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                      ,r_create_BU.curr
                      ,r_create_BU.refindividu
                      ,'BU'
                      ,l_amt
                      ,'H'
                      ,1
                      ,decode(r_slice.bucket6, 'OVER', null, r_slice.bucket6)
                      );
          end if;
          if r_slice.bucket7 is not null then
            if r_slice.bucket7 = 'OVER' then
              l_amt := to_number(l_fee2);
            else
              l_pos := instr(l_fee2, '-');
              l_amt := to_number(substr(l_fee2, 1, l_pos - 1));
              l_fee2 := substr(l_fee2, l_pos + 1, length(l_fee2));
            end if;
            cit_debug.write('Insert Bucket7: ' || r_slice.bucket7 || ' - amount: ' || l_amt); 
            insert into cit_fee_code_interet(FEE_CODE    -- Fee Code Id
                                 ,case_phase  -- 'COLL'
                                 ,devise      -- currency
                                 ,ref_lvl     -- BU iMX
                                 ,reftype_lvl -- 'BU'
                                 ,codeit      -- amount
                                 ,type        -- 'H'
                                 ,period      -- 1
                                 ,mt_max      -- slice_amount
                                 ) 
               values (r_create_BU.abrev_fee_code
                      ,'COLL'
                      ,r_create_BU.curr
                      ,r_create_BU.refindividu
                      ,'BU'
                      ,l_amt
                      ,'H'
                      ,1
                      ,decode(r_slice.bucket7, 'OVER', null, r_slice.bucket7)
                      );
          end if;
          commit;
          
        end if;
        
        close c_slice;
      end if;      
      
    end loop;
    close c_create_BU;
  end if;
  
  if bo_error = false then
    cit_debug.write('END of handling of FEE CODE: SUCCESS');
  else
    cit_debug.write('END of handling of FEE CODE: ERROR');
  end if;
  
end;
/

alter table S_LINKHEAD drop constraint PK_S_LINKHEAD;

drop index PK_S_LINKHEAD;

alter table s_linkhead modify invoiceNum varchar2(50);
alter table s_linkhead modify origInvoiceNum varchar2(50);

