
# -------------------------------------------------------------------------

MP_process = function(myoutput) {

  require(colorspace)
  # Define MP color palette:
  myoutput$mp$color = colorspace::qualitative_hcl(n = nrow(myoutput$mp$metadata), palette = "Dark 3")
  names(myoutput$mp$color) = myoutput$mp$metadata$Code
  
  # Define Preset for MP grouping:
  myoutput$mp$preset <- list('All'=1:nrow(myoutput$mp$metadata))
  mp_groups = unique(myoutput$mp$metadata$Type)
  if(length(mp_groups) > 1) { # only if there is more than one group
    for(k in seq_along(mp_groups)) {
      myoutput$mp$preset[[mp_groups[k]]] = which(myoutput$mp$metadata$Type %in% mp_groups[k])
    }
  }
  
  # Output:
  return(myoutput)

}


# -------------------------------------------------------------------------

TS_process = function(myoutput) {

  # Define dimensions:
  nST = myoutput$n_stocks
  nOM <- nrow(myoutput$om$metadata) # number of OMs
  nMP <- length(myoutput$mp$metadata$Code) # number of MPs
  nVAR <- length(myoutput$timeseries$metadata$Code) # number of variables
  nYR <- length(myoutput$timeseries$time) # number of years
  
  # Information for 6 percentiles: 5%,25%,50%,75%,95% and mean
  # DO NOT CHANGE PERCENTILE NAMES
  myoutput$timeseries$value <- array(NA, dim=c(nST, 6, nMP, nVAR, nYR), 
                                     dimnames = list(Stock = myoutput$stocks,
                                                     Percentile = c("q10", "q25", "q50", "q75", "q90", "avg"),
                                                     MPs = myoutput$mp$metadata$Code,
                                                     Var = myoutput$timeseries$metadata$Code,
                                                     Years = myoutput$timeseries$time))
  
  # Fill in TS matrix:
  for(v in 1:nVAR) {
    for(i in 1:nMP) {
      for(s in 1:nST) {
        tmp = mp_list[[i]] %>% ungroup %>% 
          filter(stock == myoutput$stocks[s]) %>%
          rename(value = sel_var[v]) %>% # select variable here
          select(year, iter, value) %>% 
          left_join(om_iter, by = "iter")
        tmp2 = tmp %>% group_by(year) %>% summarise(q10 = quantile(value, probs = 0.05, na.rm = TRUE),
                                                    q25 = quantile(value, probs = 0.25, na.rm = TRUE),
                                                    q50 = quantile(value, probs = 0.5, na.rm = TRUE),
                                                    q75 = quantile(value, probs = 0.75, na.rm = TRUE),
                                                    q90 = quantile(value, probs = 0.95, na.rm = TRUE),
                                                    avg = mean(value, na.rm = TRUE), .groups = "drop")
        tmp2 = tmp2 %>% column_to_rownames(var = "year") %>% as.matrix %>% t
        # To save results, Do this because somethings some iters are missing:
        tmp3 = matrix(NA, nrow = 6, ncol = nYR)
        tmp3[, match(as.numeric(colnames(tmp2)), myoutput$timeseries$time)] = tmp2
        # Save
        myoutput$timeseries$value[s,,i,v,] = tmp3
      } # STOCK
    } # MP
  } # VAR
  
  # Target and limit if present (length = number of variables):
  myoutput$timeseries$target <- c(NA, NA, NA, NA)
  myoutput$timeseries$limit <- c(NA, NA, NA, NA)
  
  # Output:
  return(myoutput)
  
}

# -------------------------------------------------------------------------

KOBE_process = function(myoutput) {
  
  # Define dimensions:
  nAX <- nrow(myoutput$kobe$metadata) 
  nYR <- length(myoutput$kobe$time)
  nST = myoutput$n_stocks
  nOM <- nrow(myoutput$om$metadata) # number of OMs
  nMP <- length(myoutput$mp$metadata$Code) # number of MPs

  myoutput$kobe$value <- array(NA, dim=c(nST, nsim, nOM, nMP, nAX, nYR),
                               dimnames = list(Stock = myoutput$stocks,
                                               Iter = 1:nsim,
                                               OMs = 1:nOM,
                                               MPs = myoutput$mp$metadata$Code,
                                               Var = myoutput$kobe$metadata$Code,
                                               Years = myoutput$kobe$time))
  
  # Fill in KOBE matrix:
  for(v in 1:nAX) {
    for(i in 1:nMP) {
      for(s in 1:nST) {
        tmp = mp_list[[i]] %>% ungroup %>% 
          filter(stock == myoutput$stocks[s]) %>%
          rename(value = sel_var[v]) %>% # select variable here
          filter(year >= (myoutput$timeseries$timenow + 1)) %>%
          select(year, iter, value) %>% 
          left_join(om_iter, by = "iter")
        for(k in 1:nOM) {
          tmp2 = tmp %>% 
            filter(scenario == myoutput$om$metadata$Level[k]) %>%
            pivot_wider(names_from = "year", id_cols = "iter_gr") %>%
            column_to_rownames(var = "iter_gr") %>% as.matrix
          # To save results, Do this because somethings some iters are missing:
          tmp3 = matrix(NA, nrow = nsim, ncol = ncol(tmp2))
          tmp3[as.numeric(rownames(tmp2)), match(as.numeric(colnames(tmp2)), myoutput$kobe$time)] = tmp2
          # Save
          myoutput$kobe$value[s,,k,i,v,] = tmp3
        }
      } # STOCK
    } # MP
  } # VAR
  
  # Output:
  return(myoutput)
  
}

# -------------------------------------------------------------------------

PI_process = function(myoutput) {
  
  # Define Preset for PI grouping:
  myoutput$pi$preset <- list('All'=1:nrow(myoutput$pi$metadata))
  pi_groups = unique(myoutput$pi$metadata$Type)
  if(length(pi_groups) > 1) { # only if there is more than one group
    for(k in seq_along(pi_groups)) {
      myoutput$pi$preset[[pi_groups[k]]] = which(myoutput$pi$metadata$Type %in% pi_groups[k])
    }
  }
  
  # Values:
  nPI <- nrow(myoutput$pi$metadata)
  nST = myoutput$n_stocks
  nOM <- nrow(myoutput$om$metadata) # number of OMs
  nMP <- length(myoutput$mp$metadata$Code) # number of MPs
  myoutput$pi$value <- array(NA, dim=c(nST, nsim, nOM, nMP, nPI),
                             dimnames = list(Stock = myoutput$stocks,
                                             Iter = 1:nsim,
                                             OMs = 1:nOM,
                                             MPs = myoutput$mp$metadata$Code,
                                             PIs = myoutput$pi$metadata$Code))
  
  # Counter
  count_i = 1
  
  # 1: minB
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = min(bbmsy), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 2: meanB
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(bbmsy), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  
  # 3: meanF
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(ffmsy), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  
  # 4: PGK:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        mutate(green = if_else(bbmsy > 1 & ffmsy < 1, 1, 0)) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(green), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 5: PRK:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        mutate(red = if_else(bbmsy < 1 & ffmsy > 1, 1, 0)) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(red), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  
  # 6: PBLIM:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        mutate(prob = if_else(ssb > 0.4*SSB_MSY, 1, 0)) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(prob), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  
  # 7: PBMSY:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        mutate(prob = if_else(ssb > 0.4*SSB_MSY & ssb < SSB_MSY, 1, 0)) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(prob), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 8: Mean Catch Short Term:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str & year < (sim_yr_str+3)) %>%
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(catch), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 9: Mean Catch Medium Term:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= (sim_yr_str+5) & year < (sim_yr_str+10)) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(catch), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 10: Mean Catch Long Term:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= (sim_yr_str+15) & year < (sim_yr_str+25)) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(catch), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 11: Mean TAC Short Term:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str & year < (sim_yr_str+3)) %>%
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(tac), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 12: Mean TAC Medium Term:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= (sim_yr_str+5) & year < (sim_yr_str+10)) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(tac), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 13: Mean TAC Long Term:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= (sim_yr_str+15) & year < (sim_yr_str+25)) %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(tac), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 14: TAC Uptake:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- mp_list[[i]] %>% 
        filter(year >= sim_yr_str) %>%
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = mean((catch/tac))*100, .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 15: TAC SD:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- tac_list[[i]] %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>%
          group_by(iter_gr) %>%
          summarise(value = sd(tac), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 16: TAC Change:
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- tac_list[[i]] %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>% ungroup() %>%
          group_by(iter_gr) %>%
          arrange(tac_period) %>%
          mutate(diff = (tac - lag(tac))/lag(tac)) %>% 
          na.omit %>% 
          group_by(iter_gr) %>%
          summarise(value = mean(abs(diff))*100, .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 17: PTX
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- tac_list[[i]] %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>% ungroup() %>%
          group_by(stock, iter_gr, scenario) %>%
          arrange(tac_period) %>%
          mutate(diff = (tac - lag(tac))/lag(tac)) %>%
          na.omit %>% mutate(prob = abs(diff) > 0.1) %>%
          group_by(iter_gr) %>%
          summarise(value = mean(prob), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  count_i = count_i + 1
  
  # 18: MAXTc
  for(i in 1:nMP) {
    for(s in 1:nST) {
      tmp <- tac_list[[i]] %>% 
        filter(stock == myoutput$stocks[s]) %>%
        left_join(om_iter, by = "iter") 
      for(k in 1:nOM) {
        tmp2 = tmp %>%
          filter(scenario == myoutput$om$metadata$Level[k]) %>% ungroup() %>%
          group_by(stock, iter_gr, scenario) %>%
          arrange(tac_period) %>%
          mutate(diff = (tac - lag(tac))/lag(tac)) %>%
          na.omit %>% mutate(prob = abs(diff) > 0.1) %>%
          group_by(iter_gr) %>%
          summarise(value = max(abs(diff)*100), .groups = "drop")
        # To save results, Do this because somethings some iters are missing:
        tmp3 = rep(NA, times = nsim)
        tmp3[match(tmp2$iter_gr, 1:nsim)] = tmp2 %>% pull(value)
        myoutput$pi$value[s,,k,i,count_i] = tmp3
      }
    }
  }
  
  # Define probability PIs
  myoutput$pi$is_decimal = c(rep(TRUE, times = 7), 
                             rep(FALSE, times = 9), 
                             rep(TRUE, times = 1),
                             rep(FALSE, times = 1))
  
  # Output:
  return(myoutput)
  
}

# -------------------------------------------------------------------------

FLEET_process = function(myoutput) {
  
  # Define Preset for FLEET grouping:
  myoutput$fleet$preset <- list('All'=1:nrow(myoutput$fleet$metadata))
  fleet_groups = unique(myoutput$fleet$metadata$Type)
  if(length(fleet_groups) > 1) { # only if there is more than one group
    for(k in seq_along(fleet_groups)) {
      myoutput$fleet$preset[[fleet_groups[k]]] = which(myoutput$fleet$metadata$Type %in% fleet_groups[k])
    }
  }
  
  # Define dimensions:
  nFL <- nrow(myoutput$fleet$metadata) 
  nYR <- length(myoutput$fleet$time) # number of years
  nST = myoutput$n_stocks
  nMP <- length(myoutput$mp$metadata$Code) # number of MPs
  nVAR <- length(myoutput$fleet$variables$Code)
  
  myoutput$fleet$value <- array(NA, dim=c(nST, nVAR, 6, nMP, nFL, nYR),
                                dimnames = list(Stock = myoutput$stocks,
                                                Var = myoutput$fleet$variables$Code,
                                                Percentile = c("q10", "q25", "q50", "q75", "q90", "avg"),
                                                MPs = myoutput$mp$metadata$Code,
                                                Fleet = myoutput$fleet$metadata$Code,
                                                Years = myoutput$fleet$time))
  
  # Fill in FLEET matrix:
  for(v in 1:nVAR) {
    for(f in 1:nFL) {
      for(i in 1:nMP) {
        for(s in 1:nST) {
          tmp = catch_list[[i]] %>% ungroup %>% 
            filter(stock == myoutput$stocks[s],
                   fleet == myoutput$fleet$metadata$Code[f],
                   year %in% myoutput$fleet$time ) %>%
            rename(value = sel_var[v]) %>% # select variable here
            select(year, iter, value) %>% 
            left_join(om_iter, by = "iter")
          tmp2 = tmp %>% group_by(year) %>% summarise(q10 = quantile(value, probs = 0.05, na.rm = TRUE),
                                                      q25 = quantile(value, probs = 0.25, na.rm = TRUE),
                                                      q50 = quantile(value, probs = 0.5, na.rm = TRUE),
                                                      q75 = quantile(value, probs = 0.75, na.rm = TRUE),
                                                      q90 = quantile(value, probs = 0.95, na.rm = TRUE),
                                                      avg = mean(value, na.rm = TRUE), .groups = "drop")
          tmp2 = tmp2 %>% column_to_rownames(var = "year") %>% as.matrix %>% t
          # To save results, Do this because somethings some iters are missing:
          tmp3 = matrix(NA, nrow = 6, ncol = nYR)
          #now check if nrow > 0 since some fleets may be absent for some stocks:
          if(nrow(tmp2) > 0) {
            tmp3[, match(as.numeric(colnames(tmp2)), myoutput$fleet$time)] = tmp2
            # Save
            myoutput$fleet$value[s,v,,i,f,] = tmp3
          }
        } # STOCK
      } # MP
    } # FLEET
  } # VAR
  
  # Output:
  return(myoutput)
  
}
