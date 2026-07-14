#' 清空临时表
#'
#' @param dms_token 第二个参数
#'
#' @return 两个数的和
#' @export
#'
#' @examples
#' salReturn_delete
salReturn_delete <- function(dms_token) {

  sql = paste0(" truncate table rds_erp_byd_src_t_sal_returnstock_list_input ")


  res = tsda::mysql_delete2(token = dms_token,sql_str = sql)

  return(res)

}


#' 更新插入list表和表头表体数据
#'
#' @param dms_token 第二个参数
#'
#' @return 两个数的和
#' @export
#'
#' @examples
#' salReturn_insert
salReturn_insert <- function(dms_token) {
  sql1 = paste0(" INSERT OVERWRITE table rds_erp_byd_src_t_sal_returnstock_list_input
SELECT a.*
FROM rds_erp_byd_src_t_sal_returnstock_list_input a
LEFT JOIN rds_erp_byd_src_t_sal_returnstock_list b
  ON a.FBillNo = b.FBillNo
WHERE b.FBillNo IS NULL; ")
  tsda::mysql_update2(token = dms_token,sql_str =sql1 )


  sql2 = paste0("insert into rds_erp_byd_src_t_sal_returnstock_list
select ROW_NUMBER() OVER (ORDER BY FBillNo ,Fseq,FMaterialNumber)
+ IFNULL((SELECT MAX(fid) FROM rds_erp_byd_src_t_sal_returnstock_list), 0)as	FID	,
Fdate,
FBillNo	,
FSaleOrgNumber	,
FSaleOrgName	,
FStatus 	,
FCompStatus	,
FSaleOrderNo	,
FRequestDate	,
FCustomerNumber	,
FCustomerName	,
FSellerNumber	,
FSellerName	,
FReturnReasonNumber	,
FReturnReasonName	,
FEmpNumber	,
FEmpName	,
Fseq	,
FMaterialNumber	,
FMaterialName	,
FReturnQty	,
FReturnNetValue
from rds_erp_byd_src_t_sal_returnstock_list_input;")
  tsda::mysql_update2(token = dms_token,sql_str =sql2)

  sql3 = paste0("
insert into rds_erp_byd_src_t_sal_returnstock
select
ROW_NUMBER() OVER (ORDER BY FBillNo )+(select max(fid) from rds_erp_byd_src_t_sal_returnstock) as	FID	,
 Fdate,
FBillNo	,
FSaleOrgNumber	,
FSaleOrgName	,
FStatus 	,
FCompStatus	,
FRequestDate	,
FCustomerNumber	,
FCustomerName	,
FSellerNumber	,
FSellerName	,
FReturnReasonNumber	,
FReturnReasonName	,
FEmpNumber	,
FEmpName	,
'1900-01-01' as FPostDate	,
0	as	FIsDo	,
''	as	FLogMessage	,
NOW()	as	FUpdateTime	,
0	as	FNeedUpdat
from rds_erp_byd_src_t_sal_returnstock_list_input
group by
Fdate	,
FBillNo	,
FSaleOrgNumber	,
FSaleOrgName	,
FStatus 	,
FCompStatus	,
FRequestDate	,
FCustomerNumber	,
FCustomerName	,
FSellerNumber	,
FSellerName	,
FReturnReasonNumber	,
FReturnReasonName	,
FEmpNumber	,
FEmpName	;")
  tsda::mysql_update2(token = dms_token,sql_str =sql3)

  sql4=paste0("insert into rds_erp_byd_src_t_sal_returnstockentry
select ROW_NUMBER() OVER (ORDER BY FBillNo ,Fseq,FMaterialNumber)
+ IFNULL((SELECT MAX(Fentryid) FROM rds_erp_byd_src_t_sal_returnstockentry), 0)	as	fentryid	,
fbillno	as	fbillno	,
Fseq	as	Fseq	,
FMaterialNumber	as	FMaterialNumber	,
FMaterialName	as	FMaterialName	,
REPLACE(REPLACE(SUBSTRING_INDEX(FReturnQty, ' ', 1),'#',0), ',', '')	as	FReturnQty	,
REPLACE(REPLACE(SUBSTRING_INDEX(FReturnNetValue, ' ', 1),'#',1), ',', '')	as	FReturnNetValue	,
SUBSTRING_INDEX(FReturnQty, ' ', -1)	as	FUnit	,
SUBSTRING_INDEX(FReturnNetValue, ' ', -1)	as	FCURRENCY	,
0	as	FPrice	,
0	as	FTaxAmt	,
0	as	FTaxRate	,
''	as	FSrcBillName	,
''	as	FSrcBillNo	,
0	as	FSrcSeq	,
0	as	FIsDo	,
''	as	FLogMessage	,
now()	as	FUpdateTime	,
0	as	FNeedUpdate
from rds_erp_byd_src_t_sal_returnstock_list_input;")
  tsda::mysql_update2(token = dms_token,sql_str =sql4)

  sql5=paste0("TRUNCATE TABLE rds_erp_byd_src_t_sal_returnstock_list_input;")
  res = tsda::mysql_delete2(token = dms_token,sql_str =sql5)


  return(res)

}



#' 查询list表
#'
#' @param dms_token 第二个参数
#' @param FStartDate
#' @param FEndDate
#'
#' @return 两个数的和
#' @export
#'
#' @examples
#' salReturn_select
salReturn_select <- function(dms_token,FStartDate,FEndDate) {
  sql = paste0("
               select
Fdate	月_日历年	,
FBillNo	单据编号	,
FSaleOrgNumber	销售组织编码	,
FSaleOrgName	销售组织名称	,
FStatus 	状态（抬头）（客户）	,
FCompStatus	完成状态（抬头）（客户退货）	,
FSaleOrderNo	销售订单编号	,
FRequestDate	要求日期	,
FCustomerNumber	客户编码	,
FCustomerName	客户名称	,
FSellerNumber	卖方编码	,
FSellerName	卖方名称	,
FReturnReasonNumber	退货原因编码	,
FReturnReasonName	退货原因名称	,
FEmpNumber	员工编码	,
FEmpName	员工名称	,
Fseq	行号	,
FMaterialNumber	物料编码	,
FMaterialName	物料名称	,
FReturnQty	退货数量	,
FReturnNetValue	退货净值
from rds_erp_byd_src_t_sal_returnstock_list
    WHERE FRequestDate >= '",FStartDate,"' AND FRequestDate <= '",FEndDate,"';


               ")


  res = tsda::mysql_select2(token = dms_token,sql =sql )
  return(res)

}
