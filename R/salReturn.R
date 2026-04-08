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

  sql = paste0(" truncate table rds_erp_byd_src_t_sal_ReturnStock_list_input ")


  res = tsda::mysql_delete2(token = dms_token,sql_str = sql)

  return(res)

}


#' 更新list表和表头表体数据
#'
#' @param dms_token 第二个参数
#'
#' @return 两个数的和
#' @export
#'
#' @examples
#' salReturn_insert
salReturn_insert <- function(dms_token) {
  sql = paste0(" CALL rds_erp_byd_src_proc_sal_ReturnStock_insert();  ")


  res = tsda::mysql_update2(token = dms_token,sql_str =sql )
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
from rds_erp_byd_src_t_sal_ReturnStock_list
    WHERE FRequestDate >= '",FStartDate,"' AND FRequestDate <= '",FEndDate,"';


               ")


  res = tsda::mysql_select2(token = dms_token,sql =sql )
  return(res)

}
