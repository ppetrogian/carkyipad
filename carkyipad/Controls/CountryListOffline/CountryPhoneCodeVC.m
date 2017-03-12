//
//  CountryPhoneCodeVC.m
//  DoubleUniq
//
//  Created by Pravin Mahajan on 21/10/16.
//  Copyright © 2016 ETPL. All rights reserved.
//

#import "CountryPhoneCodeVC.h"
#import "CountryCell.h"
#import "SharedInstance.h"

@interface CountryPhoneCodeVC ()<UIGestureRecognizerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrCountryCodes;
    NSMutableArray *searchCountryCodes;
}
@end

@implementation CountryPhoneCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSetUp];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self showNavBar];
    
    self.title =@"Select Country";;
    [self setCountryPopUp];

}
-(void)initSetUp{
    searchCountryCodes = [[NSMutableArray alloc] init];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - OnClick Event

- (IBAction)backbtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UITableview DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (searchCountryCodes.count>0) {
        return searchCountryCodes.count;
    }
    else if (arrCountryCodes.count>0){
        return arrCountryCodes.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentiFier = @"countryCell";
    
    CountryCell *cell;
   
    cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentiFier];
    if (cell == nil){
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CountryCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[CountryCell class]]) {
                cell = (CountryCell *)currentObject;
                break;
            }
        }
    }
    
    
    NSDictionary *country = nil;
    
    if (searchCountryCodes.count>0) {
        country= [searchCountryCodes objectAtIndex:indexPath.row];
    }
    else if (arrCountryCodes.count>0){
        country= [arrCountryCodes objectAtIndex:indexPath.row];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[country objectForKey:@"countryCode"]];
    NSLog(@"image name : %@",imageName);
    cell.img_Country.image = [UIImage imageNamed:[imageName lowercaseString]];
    cell.lbl_CountryName.text= [NSString stringWithFormat:@"%@ (%@)",[country objectForKey:@"countryName"],[country objectForKey:@"phoneCode"]];
    
    cell.img_Country.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.img_Country.layer.cornerRadius=cell.img_Country.frame.size.height / 2;
    cell.img_Country.layer.borderWidth=0.3;
    cell.img_Country.layer.masksToBounds = YES;
    cell.img_Country.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    return cell;
}

#pragma mark -UITableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSLog(@"%@",[arrCountryCodes objectAtIndex:indexPath.row]);
    
    NSDictionary *dict = nil;
    
    if (searchCountryCodes.count>0) {
        dict= [searchCountryCodes objectAtIndex:indexPath.row];
    }
    else if (arrCountryCodes.count>0){
        dict= [arrCountryCodes objectAtIndex:indexPath.row];
    }
    
    if (dict!=nil && dict.count>0) {
        [SharedInstance sharedInstance].isCountryCodeSelectedFromPopUp = YES;
        [SharedInstance sharedInstance].selCountryCodeDict = [dict mutableCopy];
        [SharedInstance sharedInstance].selCountryCode = [dict objectForKey:@"countryCode"];
        [SharedInstance sharedInstance].selCountryName = [dict objectForKey:@"countryName"];
        [SharedInstance sharedInstance].selCountryId = [dict objectForKey:@"phoneCode"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

# pragma mark - SearchBar Delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchForText:searchText];

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchForText:(NSString *)searchText{
    
    if (searchText.length>0) {
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"countryName beginswith[cd] %@", searchText];
        searchCountryCodes = [[arrCountryCodes filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
    else{
        [searchCountryCodes removeAllObjects];
    }
    
    [_tableview reloadData];
}
# pragma mark - Helper methods Delegates ------------

-(void)setRowSelected{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"countryCode matches[cd] %@",[SharedInstance sharedInstance].selCountryCode];
    
    NSArray *ArrSelCountry = [arrCountryCodes filteredArrayUsingPredicate:resultPredicate];
    
    if (ArrSelCountry.count==1) {
        int row = (int)[arrCountryCodes indexOfObject:[ArrSelCountry objectAtIndex:0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)setCountryPopUp{
    
    _searchbar.placeholder = @"Select country";
    
//    _tableview.contentInset = UIEdgeInsetsMake(0, -10, 0, 0);
    
    arrCountryCodes = [self getCountryDataByCodeWithCountryCodeArr:[NSLocale ISOCountryCodes]];
    
    [_tableview reloadData];
    
    [self performSelector:@selector(setRowSelected) withObject:nil afterDelay:0.2];
    
//    _transparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trasnsParentViewTapped:)];
    tapGesture.numberOfTapsRequired    = 1;
    tapGesture.delegate                = self;
    tapGesture.numberOfTouchesRequired = 1;
//    [_transparentView addGestureRecognizer:tapGesture];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchbar resignFirstResponder];
}

@end
