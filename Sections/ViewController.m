//
//  ViewController.m
//  Sections
//
//  Created by Vasilii on 01.06.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "ViewController.h"


static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface ViewController () {
    NSMutableArray *filteredNames; //для хранения имен
    UISearchDisplayController *searchController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
    //создадим объект класса UISearchBar и добавим его в таблицу в качестве представления заголовка, которое действует как особая строка, которая всегда отображается в верхней части таблицы. Затем создаем контроллер отображения результатов поиска. Этот контроллер инициализируется с помощью поисковой панели, предназначенной для ввода, и контроллера самого представления в качестве владельца. Кроме того, мы делаем этот контроллер представления делегатом для контроллера отображения результатов поиска, чтобы он реагировал на изменение критерия поиска. В заключение установим контроллер представления в качестве источника данных для результатов поиска, чтобы он отображал результаты поиска.
    filteredNames = [NSMutableArray array];
    UISearchBar *searshBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tableView.tableHeaderView = searshBar;
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searshBar contentsController:self];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.names allKeys] sortedArrayUsingSelector:@selector(compare:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

//далее после else для строки поиска
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.tag == 1) {
        return [self.keys count];
    } else {
        return 1;
    }
}
//определяем количество строк в разделе
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1) {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.names[key];
        return [nameSection count];
    } else {
        return [filteredNames count];
    }
}

//указыаем значение заголовка(букву группы)
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView.tag == 1) {
        return self.keys[section];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier];
    if (tableView.tag == 1) {
        NSString *key = self.keys[indexPath.section];
        NSArray *nameSection = self.names[key];
        
        cell.textLabel.text = nameSection[indexPath.row];
    } else {
        cell.textLabel.text = filteredNames[indexPath.row];
    }
    return cell;
}

#pragma mark UITableViewDelegate


- (NSArray *)sectionIndexTitlesForTableView: (UITableView *)tableView {
    
    if (tableView.tag == 1) { return self.keys;
    } else {
        return nil;
    }
}

#pragma mark UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredNames removeAllObjects];//аннулируем результаты предыдущего поиска
    if (searchString.length > 0) {//не должна быть пустая строка
        //Затем определяем предикат для сравнения имен со строкой поиска. Предикат — это объ- ект, проверяющий входное значение и возвращающий значение “да”, если значения совпа- дают, и значение “нет, если они не совпадают. Мы ищем имена, содержащие заданную под- строку. Если найдено начало строки поиска, регистрируется совпадение.
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:^BOOL(NSString *name, NSDictionary *b) {
                                      NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
                                      return range.location != NSNotFound; }];
        //просматриваем все ключи и применяем к ним предикат, чтобы получить отфильтрованный массив совпадающих имен
        for (NSString *key in self.keys) {
            NSArray *matches = [self.names[key]
                                                filteredArrayUsingPredicate: predicate]; [filteredNames addObjectsFromArray:matches];
        }
    }
    return YES;
}
@end
