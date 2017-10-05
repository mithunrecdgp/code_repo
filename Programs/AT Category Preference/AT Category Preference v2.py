from collections import defaultdict
import cPickle as pickle
import numpy as np

import sklearn as sk
import sklearn.svm as svm
import sklearn.linear_model as lm
import sklearn.ensemble as ens

import sklearn.cross_validation as cv
import sklearn.metrics as metrics

#
def load_raw_dat(filename,count=500000):
	raw_dat = []
	counter = 0;
	fh = open(filename,'r')
	fh.readline()
	for line in fh:
		counter += 1
		if counter < count:
			str_ln = line.rstrip()
			spl_ln = str_ln.split(',')
			raw_dat.append(spl_ln)
		else:
			break
	fh.close()
	return raw_dat
 
 
#
def load_raw_dat_sk(filename,rkeys):
	raw_dat = []
	fh = open(filename,'r')
	fh.readline()
	for line in fh:
		str_line = line.rstrip()
		spl_ln = str_line.split(',')
		try:
			if spl_ln[0] in rkeys:
				raw_dat.append(spl_ln)
		except KeyError:
			pass
	fh.close()
	return raw_dat


#
def load_customer_keys(filename):
	raw_ckeys = {}
	fh = open(filename,'r')
	fh.readline()
	for line in fh:
		str_ln = line.rstrip()
		spl_ln = str_ln.split(',')
		raw_ckeys[spl_ln[0]] = 0
	fh.close()
	req_keys = raw_ckeys.keys()
	return req_keys

#
def build_shaped_map(raw_dat,req_cols=None):
	req_mkeys = [item[0] for item in raw_dat]
	cat_list = list(set([item[1] for item in raw_dat]))
	cat_map = {}
	for index,item in enumerate(cat_list):
		cat_map[item] = index
	user_dict = {}
	for item in req_mkeys:
		user_dict[item] = [[0.0,0.0,0.0,0.0] for itr in range(0,len(cat_list))]
	ftr_list = req_cols
	ctr = 0
	for itr in ftr_list:
		for item in raw_dat:
			try:
				user_dict[item[0]][cat_map[item[1]]][ctr] = float(item[itr])
			except KeyError:
				pass
		ctr +=1
	return user_dict,cat_map

#
def build_shaped_map_alt(raw_dat,req_cols=None,cat_map=None):
	req_mkeys = [item[0] for item in raw_dat]
	cat_list = list(set([item[1] for item in raw_dat]))
	if cat_map == None:
		cat_map = {}
		for index,item in enumerate(cat_list):
			cat_map[item] = index
	user_dict = {}
	for item in req_mkeys:
		user_dict[item] = [[0.0,0.0,0.0,0.0] for itr in range(0,len(cat_list))]
	ftr_list = req_cols
	ctr = 0
	for itr in ftr_list:
		for item in raw_dat:
			try:
				user_dict[item[0]][cat_map[item[1]]][ctr] = float(item[itr])
			except KeyError:
				pass
		ctr +=1
	return user_dict

#
def build_map(raw_dat):
	req_mkeys = [item[0] for item in raw_dat]
	cat_list = list(set([item[1] for item in raw_dat]))
	cat_map = {}
	for index,item in enumerate(cat_list):
		cat_map[item] = index
	rev_map = {}
	for key,val in cat_map.iteritems():
		rev_map[val] = key
	return rev_map

#
def build_shaped_map_y(raw_dat,req_cols=None):
	req_mkeys = [item[0] for item in raw_dat]
	cat_list = list(set([item[1] for item in raw_dat]))
	cat_map = {}
	for index,item in enumerate(cat_list):
		cat_map[item] = index
	user_dict = {}
	for item in req_mkeys:
		user_dict[item] = [[0.0] for itr in range(0,len(cat_list))]
	ftr_list = req_cols
	ctr = 0
	for itr in ftr_list:
		for item in raw_dat:
			try:
				user_dict[item[0]][cat_map[item[1]]][ctr] = float(item[itr])
			except KeyError:
				pass
		ctr +=1
	return user_dict

#
def build_shaped_map_y_alt(raw_dat,req_cols=None,cat_map=None):
	req_mkeys = [item[0] for item in raw_dat]
	cat_list = list(set([item[1] for item in raw_dat]))
	if cat_map == None:
		cat_map = {}
		for index,item in enumerate(cat_list):
			cat_map[item] = index
	user_dict = {}
	for item in req_mkeys:
		user_dict[item] = [[0.0] for itr in range(0,len(cat_list))]
	ftr_list = req_cols
	ctr = 0
	for itr in ftr_list:
		for item in raw_dat:
			try:
				user_dict[item[0]][cat_map[item[1]]][ctr] = float(item[itr])
			except KeyError:
				pass
		ctr +=1
	return user_dict


#
def get_percentage_counts(raw_x,ncols=9):
	for key,value in raw_x.iteritems():
		for itr in range(0,ncols):
			to_sum = sum([item[itr] for item in value])
			for index,row in enumerate(value):
				if to_sum != 0:
					raw_x[key][index][itr] = raw_x[key][index][itr]/to_sum
	return None

#
def build_y(raw_x,idx=0):
	user_y = {}
	for key,value in raw_x.iteritems():
		user_y[key] = [[value[itr][idx]] for itr in range(0,len(value))]
	return user_y

#
def convert_xy_trft(rdat_xy,rkeys):
	#all_dat_xy = [rdat_xy[rkey] for rkey in rkeys]
	all_dat_xy = []
	for rkey in rkeys:
		try:
			all_dat_xy.append(rdat_xy[rkey])
		except KeyError:
			pass
	app_all_dat_xy = []
	for item in all_dat_xy:
		app_all_dat_xy.extend(item)
	rv_arr = np.asarray(app_all_dat_xy)
	return rv_arr

#
def convert_xy_tsft(rdat_xy,rkeys):
	#all_dat_xy = [np.asarray(rdat_xy[rkey]) for rkey in rkeys]
	all_dat_xy = []
	for rkey in rkeys:
		try:
			all_dat_xy.append(np.asarray(rdat_xy[rkey]))
		except:
			pass
	return all_dat_xy

#
def convert_y_cat(dat_y):
	dat_yc = []
	for item in dat_y:
		if item[0] > 0.0:
			dat_yc.append('R')
		else:
			dat_yc.append('NR')
	rv = np.asarray(dat_yc)
	return rv

#
def purchase_baseline_score(data,itr=0,fg=0):
	if fg == 0:
		rq_preds = [(index,item[itr])for index,item in enumerate(data) if item[itr] != 0]
	else:
		rq_preds = [(index,item)for index,item in enumerate(data) if item != 0]
	sorted_preds = sorted(rq_preds,key=lambda x:x[1],reverse=True)
	rq_order = [item[0] for item in sorted_preds]
	return rq_order

#
def get_relevance_scores(predicted_order,act_rel):
	rq_rel = [act_rel[item] for item in predicted_order]
	return rq_rel

#
def predict_for_cust(predictor,data):
	preds = predictor.predict_proba(data)
	rq_preds = [(index,item[1]) for index,item in enumerate(preds)]
	sorted_preds = sorted(rq_preds,key=lambda x:x[1],reverse=True)
	rq_order = [item[0] for item in sorted_preds]
	return rq_order

#
def score_for_cust(predictor,data):
	def baseline_val(preds):
		bsl_val = min([item[1] for item in preds])
		return bsl_val
	preds = predictor.predict_proba(data)
	bsl_val =  baseline_val(preds)
	rq_preds = [(index,item[1]) for index,item in enumerate(preds) if item[1] > bsl_val]
	sorted_preds = sorted(rq_preds,key=lambda x:x[1],reverse=True)
	rq_order = [item[0] for item in sorted_preds]
	return rq_order

# Compute Discounted Cumulative Gain
def compute_dcg(rank_list,k=2):
	sub_list = np.asfarray(rank_list)[:k]
	dcg = 0.0
	if sub_list.size:
		dcg = sub_list[0] + np.sum(np.diagonal(sub_list[1:]/np.log2(np.arange(2,sub_list.size+1))))
		#dcg = np.sum(sub_list)
	return dcg

# Compute Normalized Discounted Cumulative Gain
def compute_ndcg_k(rank_list,k=2):
	ndcg = 0.0
	dcg_max = compute_dcg(sorted(rank_list,reverse=True),k)
	if dcg_max == 0:
		ndcg == 0.0
	else:
		ndcg = compute_dcg(rank_list,k)/dcg_max
	return ndcg

# Evalute the NDCG for the test set
def compute_mean_ndcg(dat_x,dat_y,itr=2,rk=2):
	mndcg = []
	for cust_dat_x,cust_dat_y in zip(dat_x,dat_y):
		rnks = purchase_baseline_score(cust_dat_x,itr)
		rnk_rel = get_relevance_scores(rnks,cust_dat_y)
		mndcg.append(compute_ndcg_k(rnk_rel,rk))
	return mndcg

#
def compute_mean_ndcg_alt(dat_x,dat_y,predictor,bsl=0,itr=3,rk=2):
	mndcg = []
	for cust_dat_x,cust_dat_y in zip(dat_x,dat_y):
		if bsl == 0:
			ftr_flt = np.asarray([1,1,1,1])
			#rnks = predict_for_cust(predictor,cust_dat_x*ftr_flt)
			rnks = score_for_cust(predictor,cust_dat_x)
		else:
			rnks = purchase_baseline_score(cust_dat_x,itr)
		rnk_rel = get_relevance_scores(rnks,cust_dat_y)
		mndcg.append(compute_ndcg_k(rnk_rel,rk))
	return mndcg

# Normalized No of correct ranks
def compute_rank_metric(predicted_order,act_rel):
	rq_order_map = {}
	for index,item in enumerate(act_rel):
		rq_order_map[item] = index
	rank_metric = 0.0
	for index,c_rk in enumerate(predicted_order):
		try:
			if index <= rq_order_map[c_rk]:
				rank_metric += 1
		except KeyError:
			pass
	if rank_metric != 0:
		rank_metric /= len(act_rel)
	return rank_metric

#
def compute_metric_ex_match(dat_x,dat_y,predictor,bsl=0,itr=2,rk=2):
	count = 0.0
	for cust_dat_x,cust_dat_y in zip(dat_x,dat_y):
		lim_dat_y = purchase_baseline_score(cust_dat_y,0,1)
		if bsl == 0:
			rnks = score_for_cust(predictor,cust_dat_x)
		else:
			rnks = purchase_baseline_score(cust_dat_x,itr)
		if len(lim_dat_y[0:rk]) < len(rnks[0:rk]):
			lim_val = len(lim_dat_y[0:rk])
		elif len(lim_dat_y[0:rk]) == len(rnks[0:rk]):
			lim_val = len(lim_dat_y[0:rk])
		else:
			lim_val = len(rnks[0:rk])
		if rnks[0:lim_val] == lim_dat_y[0:lim_val]:
			count += 1
	return count

#
def compute_metric_pr_match(dat_x,dat_y,predictor,bsl=0,itr=2,rk=2):
	count = 0.0
	for cust_dat_x,cust_dat_y in zip(dat_x,dat_y):
		lim_dat_y = purchase_baseline_score(cust_dat_y,0,1)
		if bsl == 0:
			rnks = score_for_cust(predictor,cust_dat_x)
		else:
			rnks = purchase_baseline_score(cust_dat_x,itr)
		if len(lim_dat_y[0:rk]) < len(rnks[0:rk]):
			lim_val = len(lim_dat_y[0:rk])
		elif len(lim_dat_y[0:rk]) == len(rnks[0:rk]):
			lim_val = len(lim_dat_y[0:rk])
		else:
			lim_val = len(rnks[0:rk])
		rmtr = compute_rank_metric(rnks[0:rk],lim_dat_y[0:rk])
		count += rmtr
	return count


#
def filter_zero_trans(ckeys,dat_y):
	def check_zero(s_dat_y):
		rv = 0
		if np.sum(s_dat_y) > 0:
			rv =1
		return rv
	rkeys = [ckey for ckey in ckeys if check_zero(dat_y[ckey])==1]
	return rkeys

#
def filter_zero_var(ckeys,dat_x,itr=2):
	def check_zero(s_dat_y):
		rv = 0
		if np.sum(s_dat_y) > 0:
			rv =1
		return rv
	rkeys = []
	for ckey in ckeys:
		cp_val = np.asarray(dat_x[ckey])[:,itr]
		if check_zero(cp_val) == 1:
			rkeys.append(ckey)
	return rkeys

# Save the model predictions for a set of customers
def write_outputs(ckeys,data,predictor,revmap,out_file_preds):
	all_preds = [score_for_cust(predictor,item) for item in data]
	fh = open(out_file_preds,'w')
	for pred,ckey in zip(all_preds,ckeys):
		for index,o_pred in enumerate(pred):
			fh.write(ckey+','+str(rev_map[o_pred])+','+str(index)+'\n')
	fh.close()
	return None

#
def get_sub_scores(all_scores,bsl=0,rk=0):
	sub_scores = []
	for item in all_scores:
		sub_scores.append(item[rk][bsl])
	return sub_scores

model_file = 'ranking_clf.pkl'
cat_file = 'cat_map.pkl'
clf2 = pickle.load(open(model_file,'r'))
cat_map = pickle.load(open(cat_file,'r'))
data_file = 'AT_Cat_Pref.csv'
cust_keys = load_customer_keys(data_file)
metric_model_all = []
tot_nz_custs = []
for citr in range(1,19):
	pr_cust_keys = {}
	for key in cust_keys[citr*100000:(citr+1)*100000]:
		pr_cust_keys[key] = 0
	raw_data = load_raw_dat_sk(data_file,pr_cust_keys)
	user_data_all = build_shaped_map_alt(raw_data,[2,3,4,5],cat_map)
	user_data_y_pre = build_shaped_map_y_alt(raw_data,[6],cat_map)
	get_percentage_counts(user_data_y_pre,1)
	user_data_y = build_y(user_data_y_pre)
	all_ckeys = list(set(user_data_y.keys()))
	nz_keys = filter_zero_trans(all_ckeys,user_data_y)
	nz_keys_af = filter_zero_var(nz_keys,user_data_all,1)
	#nz_keys_af2 = nz_keys_af
	nz_keys_af2 = filter_zero_var(nz_keys_af,user_data_all,1)
	print 'no of scored custs :' + str(len(nz_keys_af2))
	tot_nz_custs.append(len(nz_keys_af2))
	dat_x_ts = convert_xy_tsft(user_data_all,nz_keys_af2)
	dat_y_ts = convert_xy_tsft(user_data_y,nz_keys_af2)
	rk_scores = []
	for rq_rk in [1,2,3]:
		metric_model =  compute_metric_pr_match(dat_x_ts,dat_y_ts,clf2,0,2,rq_rk)
		#metric_model_pre = compute_mean_ndcg_alt(dat_x_ts,dat_y_ts,clf2,0,2,rq_rk)
		#metric_model = np.mean(metric_model_pre)
		print 'model metric :' + str(metric_model)
		metric_baseline = compute_metric_pr_match(dat_x_ts,dat_y_ts,clf2,1,2,rq_rk)
		#metric_baseline_pre = compute_mean_ndcg_alt(dat_x_ts,dat_y_ts,clf2,1,2,rq_rk)
		#metric_baseline = np.mean(metric_baseline_pre)
		print 'baseline metric :' + str(metric_baseline)
		print '\n'
		rk_scores.append([metric_model,metric_baseline])
	metric_model_all.append(rk_scores)
	del pr_cust_keys
	del raw_data
	del user_data_all
	del user_data_y_pre
	del user_data_y
	del all_ckeys
	del nz_keys
	del nz_keys_af
	del dat_x_ts
	del dat_y_ts

'''mndcg_model = compute_mean_ndcg_alt(dat_x_ts,dat_y_ts,clf2,0,2,3)
mval_ndcg_model = np.mean(mndcg_model)

mndcg_baseline = compute_mean_ndcg_alt(dat_x_ts,dat_y_ts,clf2,1,2,3)
mval_ndcg_baseline = np.mean(mndcg_baseline)'''




